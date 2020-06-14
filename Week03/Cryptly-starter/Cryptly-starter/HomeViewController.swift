/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class HomeViewController: UIViewController{

  @IBOutlet weak var view1: LabelView!
  @IBOutlet weak var view2: LabelView!
  @IBOutlet weak var view3: LabelView!
  @IBOutlet weak var view4: LabelView!
  @IBOutlet weak var view5: LabelView!
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var view1TextLabel: UILabel!
  @IBOutlet weak var view2TextLabel: UILabel!
  @IBOutlet weak var view3TextLabel: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  @IBOutlet weak var mostFallingHeadingLabel: UILabel!
  @IBOutlet weak var mostRisingHeadingLabel: UILabel!
  @IBOutlet weak var mostFallingBodyLabel: UILabel!
  @IBOutlet weak var mostRisingBodyLabel: UILabel!
  
  let cryptoData = DataGenerator.shared.generateData()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLabels()
    setView1Data()
    setView2Data()
    setView3Data()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.registerForTheme()
    ThemeManager.shared.set(theme: themeSwitch.isOn ? DarkTheme() : LightTheme())
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.unregisterForTheme()
  }

  func setupViews() {
  }
  
  func setupLabels() {
    headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    view1TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    view2TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    
    if let result = cryptoData?.filter({$0.trend == .falling}).map({$0.valueRise}).min() {
      mostFallingBodyLabel.text = String(format: "%.2f", result)
    }
    if let result = cryptoData?.filter({$0.trend == .rising}).map({$0.valueRise}).max() {
      mostRisingBodyLabel.text = String(format: "%.2f", result)
    }
  }
  
  func setView1Data() {
    view1TextLabel.text = cryptoData?
      .map({cryptoCurrency in cryptoCurrency.name})
      .joined(separator: ", ")
  }
  
  func setView2Data() {
    view2TextLabel.text = cryptoData?
      .filter({cryptoCurrency in cryptoCurrency.currentValue > cryptoCurrency.previousValue})
      .map({cryptoCurrency in cryptoCurrency.name})
      .joined(separator: ", ")
  }
  
  func setView3Data() {
    view3TextLabel.text = cryptoData?
    .filter({cryptoCurrency in cryptoCurrency.currentValue < cryptoCurrency.previousValue})
    .map({cryptoCurrency in cryptoCurrency.name})
    .joined(separator: ", ")
  }
  
  @IBAction func switchPressed(_ sender: Any) {
    ThemeManager.shared.set(theme: themeSwitch.isOn ? DarkTheme() : LightTheme())
  }
}

extension HomeViewController: Themeable {
  func registerForTheme() {
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.init("themeChanged"), object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    guard let theme = ThemeManager.shared.currentTheme else { return }
    view1.setupView(theme: theme)
    view2.setupView(theme: theme)
    view3.setupView(theme: theme)
    view4.setupView(theme: theme)
    view5.setupView(theme: theme)
    
    view1TextLabel.textColor = theme.textColor
    view2TextLabel.textColor = theme.textColor
    view3TextLabel.textColor = theme.textColor
    
    mostRisingHeadingLabel.textColor = theme.textColor
    mostFallingHeadingLabel.textColor = theme.textColor
    
    mostRisingBodyLabel.textColor = theme.textColor
    mostFallingBodyLabel.textColor = theme.textColor
    
    headingLabel.textColor = theme.textColor
    
    view.backgroundColor = theme.backgorundColor
  }
  
  
}
