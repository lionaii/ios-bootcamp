import UIKit

protocol Roundable {
  var cornerRadius: CGFloat { get }
  func round()
}

class LabelView: UIView, Roundable {
  var cornerRadius: CGFloat = 10.0
  
  func setupView(theme: Theme? = nil) {
    layer.borderWidth = 1.0
    layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4
    layer.shadowOpacity = 0.8
    guard let theme = theme else { return }
    backgroundColor = theme.backgorundColor
    layer.borderColor = theme.borderColor.cgColor
    round()
  }
  
  func round() {
    layer.cornerRadius = cornerRadius
  }
}
