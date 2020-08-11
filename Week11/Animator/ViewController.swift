//
//  ViewController.swift
//  Animator
//
//  Created by Ruslan on 8/10/20.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var roundButton: UIButton!
  @IBOutlet weak var scaleUpButton: UIButton!
  @IBOutlet weak var rotateRightButton: UIButton!

  @IBOutlet weak var animationObject: UIView!

  @IBOutlet weak var roundConstraint: NSLayoutConstraint!
  @IBOutlet weak var scaleConstraint: NSLayoutConstraint!
  @IBOutlet weak var rotateConstraint: NSLayoutConstraint!

  let buttonSize: CGFloat = 50
  var isMenuShown = true
  var rotationCount: CGFloat = 1
  var animator: UIViewPropertyAnimator?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    playButton.layer.cornerRadius = playButton.intrinsicContentSize.width / 2
    roundButton.layer.cornerRadius = roundButton.intrinsicContentSize.width / 2
    scaleUpButton.layer.cornerRadius = scaleUpButton.intrinsicContentSize.width / 2
    rotateRightButton.layer.cornerRadius = rotateRightButton.intrinsicContentSize.width / 2
    self.view.bringSubviewToFront(playButton)
  }
    
  func initAnimator() {
    if animator == nil {
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut)
        animator!.addCompletion({ _ in
            self.animator = nil
            self.toggle()
            self.playButton.isEnabled = true
        })
    }
  }
    
  func toggle() {
    self.playButton.isEnabled = false
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: self.isMenuShown ? 0.7 : 0.4,
      initialSpringVelocity: 0,
      options: [.allowUserInteraction],
      animations: {
        self.rotateConstraint.constant = self.isMenuShown ? -self.buttonSize : self.buttonSize / 4
        self.scaleConstraint.constant = self.isMenuShown ? -self.buttonSize : self.buttonSize / 4
        self.roundConstraint.constant = self.isMenuShown ? -self.buttonSize : self.buttonSize / 4
        self.view.layoutIfNeeded()
        self.isMenuShown.toggle()
    }, completion: { _ in
        if self.animator == nil {
            self.playButton.isEnabled = true
        } else {
            self.animator!.startAnimation()
        }
    })
  }

  @IBAction func toggleMenu(_ sender: Any) {
    toggle()
  }

  @IBAction func colorChangeAnimation(_ sender: Any) {
    initAnimator()
    animator?.addAnimations({
        self.animationObject.backgroundColor = UIColor(
            red: CGFloat(Double.random(in: 0.0...1.0)),
            green: CGFloat(Double.random(in: 0.0...1.0)),
            blue: CGFloat(Double.random(in: 0.0...1.0)),
            alpha: 1.0)
        self.view.layoutIfNeeded()
    }, delayFactor: 1)
  }

  @IBAction func roundEdgeAnimation(_ sender: Any) {
    initAnimator()
    animator?.addAnimations({
      self.animationObject.layer.cornerRadius = self.animationObject.frame.width / CGFloat(Double.random(in: 1.0...4.0))
      self.view.layoutIfNeeded()
    }, delayFactor: 1)
  }

  @IBAction func rotateAnimation(_ sender: Any) {
    initAnimator()
    animator?.addAnimations({
      self.animationObject.transform = CGAffineTransform(
        rotationAngle: .pi / 2 * self.rotationCount
      )
      self.rotationCount += 1
      self.view.layoutIfNeeded()
    }, delayFactor: 1)
  }
}

