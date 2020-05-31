//
//  ViewController.swift
//  hwweek1
//
//  Created by Руслан Рахимов on 30.05.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
    }
    
    struct ColorComponent {
        let name: String
        let minValue: UInt
        let maxValue: UInt
    }
    
    struct ColorModel {
        let name: String
        let components: Array<ColorComponent>
    }
    
    enum ColorMode {
        case rgb, hsb
        
        func getComponentsInfo() -> Array<ColorComponent> {
            switch self {
            case .rgb:
                return [
                    ColorComponent(name: "Red", minValue: 0, maxValue: 255),
                    ColorComponent(name: "Green", minValue: 0, maxValue: 255),
                    ColorComponent(name: "Blue", minValue: 0, maxValue: 255),
                ]
            default:
                return [
                    ColorComponent(name: "Hue", minValue: 0, maxValue: 360),
                    ColorComponent(name: "Saturation", minValue: 0, maxValue: 100),
                    ColorComponent(name: "Brightness", minValue: 0, maxValue: 100),
                ]
            }
        }
    }
    
    var currentMode: ColorMode = .rgb
    
    @IBOutlet weak var colorName: UILabel!
    
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var thirdSlider: UISlider!
    
    @IBOutlet weak var firstSliderName: UILabel!
    @IBOutlet weak var secondSliderName: UILabel!
    @IBOutlet weak var thirdSliderName: UILabel!
    
    @IBOutlet weak var firstSliderValue: UILabel!
    @IBOutlet weak var secondSliderValue: UILabel!
    @IBOutlet weak var thirdSliderValue: UILabel!
    
    @IBAction func setColor() {
        let alertController = UIAlertController(title: "What an amazing choice!", message: "Name your color:", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.colorName.text = alertController.textFields![0].text
            switch self.currentMode {
            case .rgb:
                self.view.backgroundColor = UIColor(
                    red: CGFloat(self.firstSlider.value.rounded()) / 255.0,
                    green: CGFloat(self.secondSlider.value.rounded()) / 255.0,
                    blue: CGFloat(self.thirdSlider.value.rounded()) / 255.0,
                    alpha: 1.0)
            case .hsb:
                self.view.backgroundColor = UIColor(
                    hue: CGFloat(self.firstSlider.value.rounded()) / 360.0,
                    saturation: CGFloat(self.secondSlider.value.rounded()) / 100.0,
                    brightness: CGFloat(self.thirdSlider.value.rounded()) / 100.0,
                    alpha: 1.0)
            }
            
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func reset() {
        
        let colorComponents = currentMode.getComponentsInfo()
        
        firstSliderName.text = colorComponents[0].name
        firstSlider.minimumValue = Float(colorComponents[0].minValue)
        firstSlider.maximumValue = Float(colorComponents[0].maxValue)
        firstSlider.value = firstSlider.minimumValue
        firstSliderValue.text = String(Int(firstSlider.value))
        
        secondSliderName.text = colorComponents[1].name
        secondSlider.minimumValue = Float(colorComponents[1].minValue)
        secondSlider.maximumValue = Float(colorComponents[1].maxValue)
        secondSlider.value = secondSlider.minimumValue
        secondSliderValue.text = String(Int(secondSlider.value))
        
        thirdSliderName.text = colorComponents[2].name
        thirdSlider.minimumValue = Float(colorComponents[2].minValue)
        thirdSlider.maximumValue = Float(colorComponents[2].maxValue)
        thirdSlider.value = firstSlider.minimumValue
        thirdSliderValue.text = String(Int(thirdSlider.value))
    }
    
    @IBAction func firstSliderMoved(_ slider: UISlider) {
        firstSliderValue.text = String(Int(slider.value.rounded()))
    }
    
    @IBAction func secondSliderMoved(_ slider: UISlider) {
        secondSliderValue.text = String(Int(slider.value.rounded()))
    }
    
    @IBAction func thirdSliderMoved(_ slider: UISlider) {
        thirdSliderValue.text = String(Int(slider.value.rounded()))
    }
    
    @IBAction func modeChanged(_ sender: Any) {
        switch currentMode {
        case .rgb:
            currentMode = .hsb
        case .hsb:
            currentMode = .rgb
        }
        reset()
    }
}

