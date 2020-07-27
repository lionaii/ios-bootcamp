//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var clueLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scoreLabel: UILabel!

  var clues: [Clue] = []
  var correctAnswerClue: Clue?
  var points: Int = 0
  var randomNumber: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.layer.backgroundColor = UIColor.clear.cgColor
    tableView.backgroundColor = .clear

    self.scoreLabel.text = "\(self.points)"

    if let imageURL = URL(string: "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg"){
      logoImageView.load(url: imageURL)
    }

    getClues()
  }

  func setUpView() {
    DispatchQueue.main.async {
      self.categoryLabel.text = self.clues[self.randomNumber].category.title
      self.clueLabel.text = self.clues[self.randomNumber].question
      self.scoreLabel.text = String(self.points)
      self.tableView.reloadData()
    }
  }

  func getClues() {
    Networking.sharedInstance.getRandomCategory(completion: { (categoryId) in
      guard let id = categoryId else { return }
      Networking.sharedInstance.getAllCluesInCategory(categoryID: id) { (clues) in
        self.clues = clues
        self.randomNumber = Int.random(in: 0..<clues.count)
        self.correctAnswerClue = self.clues[self.randomNumber]
        self.setUpView()
      }
    })
  }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return clues.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.layer.backgroundColor = UIColor.clear.cgColor
    cell.backgroundColor = .clear
    cell.textLabel!.text = clues[indexPath.row].answer
    cell.textLabel!.textAlignment = .center
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let correctAnswer = correctAnswerClue else {
      return
    }
    if clues[indexPath.row].id == correctAnswer.id {
      points += clues[indexPath.row].value ?? 0
    }
    getClues()
  }
}

