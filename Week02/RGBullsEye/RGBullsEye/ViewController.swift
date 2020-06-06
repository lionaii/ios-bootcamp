/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetTextLabel: UILabel!
    @IBOutlet weak var guessLabel: UILabel!

    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    let game = BullsEyeGame()
    var currentValue = RGB()

    @IBAction func aSliderMoved(sender: UISlider) {
        currentValue = RGB(
            r: Int(redSlider.value.rounded()),
            g: Int(greenSlider.value.rounded()),
            b: Int(blueSlider.value.rounded())
        )
        updateView()
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
        guessLabel.backgroundColor = UIColor(rgbStruct: currentValue)
        targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
        redLabel.text = "R \(currentValue.r)"
        greenLabel.text = "G \(currentValue.g)"
        blueLabel.text = "B \(currentValue.b)"
        scoreLabel.text = "Score: \(game.score)"
        roundLabel.text = "Round: \(game.round)"
        redSlider.value = Float(currentValue.r)
        greenSlider.value = Float(currentValue.g)
        blueSlider.value = Float(currentValue.b)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startOver()
    }
}

