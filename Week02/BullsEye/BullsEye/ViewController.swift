//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var game: BullsEyeGame = BullsEyeGame()
    var currentValue: Int = 0
    
    var quickDiff: Int {
        return abs(game.targetValue - currentValue)
    }
    
    @IBAction func aSliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value.rounded())
        slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
    }

    @IBAction func showAlert() {
        let (title, points) = game.finishRound(with: currentValue)
        let message = "You scored \(points) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.game.startNewRound()
            self.currentValue = self.game.defaultValue
            self.updateView()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    @IBAction func startOver() {
        game.reset()
        currentValue = game.defaultValue
        updateView()
    }

    func updateView() {
        targetLabel.text = String(game.targetValue)
        scoreLabel.text = String(game.score)
        roundLabel.text = String(game.round)
        slider.value = Float(self.currentValue)
        slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startOver()
    }
}



