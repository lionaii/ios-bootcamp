//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
import CoreData

protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
  let searchController = UISearchController(searchResultsController: nil)
  let defaults = UserDefaults.standard
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var fetchedRC: NSFetchedResultsController<Sandwich>!
  var sandwiches = [Sandwich]()
  var filteredSandwiches = [Sandwich]()
  var query = ""
  var dontRefreshTable = true

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    if(isFirstLaunch()) {
      loadSandwichesFromJSON()
    } else {
      refresh()
    }

    dontRefreshTable = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    searchController.searchBar.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }
  
  func loadSandwichesFromJSON() {
    guard let sandwichesJSONURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else {
      return
    }

    let decoder = JSONDecoder()

    do {
      let sandwichesData = try Data(contentsOf: sandwichesJSONURL)
      let sandwichArray = try decoder.decode([SandwichData].self, from: sandwichesData)
      for newSandwich in sandwichArray {
        saveSandwich(newSandwich)
      }
    } catch let error {
      print(error)
    }
  }


  func refresh() {
    let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
    let sort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
    request.sortDescriptors = [sort]
    do {
      fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Sandwich.name), cacheName: nil)
      try fetchedRC.performFetch()
      if let objs = fetchedRC.fetchedObjects {
        sandwiches = objs
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }


  func saveSandwich(_ sandwich: SandwichData) {
    let sandwichData = Sandwich(entity: Sandwich.entity(), insertInto: context)
    sandwichData.name = sandwich.name
    sandwichData.imageName = sandwich.imageName
    sandwichData.sauce = SauceAmountModel(entity: SauceAmountModel.entity(), insertInto: context)
    sandwichData.sauce?.amount = sandwich.sauceAmount.rawValue
    sandwiches.append(sandwichData)

    appDelegate.saveContext()
    refresh()
    if(!dontRefreshTable) {
      tableView.reloadData()
    }
  }

  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }
  
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String,
                                  sauceAmount: SauceAmount? = nil) {
        filteredSandwiches = sandwiches.filter { (sandwhich: Sandwich) -> Bool in
          let doesSauceAmountMatch = sauceAmount == .any || sandwhich.sauce?.amount! == sauceAmount?.rawValue

          if isSearchBarEmpty {
            return doesSauceAmountMatch
          } else {
            return doesSauceAmountMatch && sandwhich.name!.lowercased()
              .contains(searchText.lowercased())
          }
        }

    tableView.reloadData()
  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering =
      searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive &&
      (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredSandwiches.count : sandwiches.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
      else { return UITableViewCell() }

    let sandwich = isFiltering ? filteredSandwiches[indexPath.row] : sandwiches[indexPath.row]

    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName!)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauce?.amount

    return cell
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let sandwich = sandwiches[indexPath.row]
      sandwiches.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      context.delete(sandwich)
      appDelegate.saveContext()
      refresh()
    }
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar

    let sauceAmountRawValue = defaults.object(forKey: "SauceType") as? String ?? String()

    let sauceAmount: SauceAmount?
    if sauceAmountRawValue.isEmpty {
      sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    } else {
      sauceAmount = SauceAmount(rawValue: sauceAmountRawValue)
      searchBar.selectedScopeButtonIndex = determineCurrentScopeButtonIndex(for: sauceAmount)
    }

    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
                 selectedScopeButtonIndexDidChange selectedScope: Int) {
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![selectedScope])

    defaults.set(sauceAmount?.rawValue, forKey: "SauceType")

    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - Helper Functions
func determineCurrentScopeButtonIndex(for sauceAmount: SauceAmount?) -> Int {
  switch(sauceAmount) {
  case .any:
    return 0
  case .tooMuch:
    return 2
  default:
    return 1
  }
}

func isFirstLaunch() -> Bool {
  if !UserDefaults.standard.bool(forKey: "FirstLaunch") {
    UserDefaults.standard.set(true, forKey: "FirstLaunch")
    return true
  }
  return false
}

