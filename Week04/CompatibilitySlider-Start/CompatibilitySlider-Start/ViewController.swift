//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!

    var compatibilityItems = ["Cats", "Dogs", "Apples", "Cheese"] // Add more!
    var currentItemIndex = 0

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    func setupCurrentPersonView() {
        guard currentPerson != nil else { return }
        questionLabel.text = "\(currentPerson!.name), what do you think about ..."
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        assert(sender == slider)
    }
    
    @IBAction func sliderEditingEnded(_ sender: UISlider) {
        assert(sender == slider)
        sender.setValue(sender.value.rounded(), animated: true)
    }

    @IBAction func didPressNextItemButton(_ sender: Any) {
        let currentItem = compatibilityItems[currentItemIndex]
        currentPerson?.items.updateValue(slider.value, forKey: currentItem)
        if currentItemIndex + 1 < compatibilityItems.count {
            currentItemIndex += 1
            updateView()
        }
        else {
            if currentPerson == person1 {
                currentPerson = person2
                currentItemIndex = 0
                updateView()
            } else {
                finish()
            }
        }
    }
    
    func finish() {
        let compatibility = person1.calculateCompatibility(with: person2)
        let message = "You scored \(compatibility) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.reset()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func updateView() {
        setupCurrentPersonView()
        compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
        slider.value = 3.0
    }
    
    func reset() {
        currentItemIndex = 0
        person1.items = [:]
        person2.items = [:]
        currentPerson = person1
        updateView()
    }
}

