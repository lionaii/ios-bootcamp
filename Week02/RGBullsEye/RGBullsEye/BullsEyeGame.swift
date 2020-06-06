//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Ruslan on 06.06.2020.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

class BullsEyeGame {
    
    typealias RoundResult = (msg: String, points: Int)
    let defaultValue: RGB = RGB()
    var targetValue: RGB = RGB()
    var score = 0
    var round = 0
    
    func finishRound(with value: RGB) -> RoundResult {
        // sqrt(3.0) is maximum possible difference
        let difference = Int((value.difference(target: targetValue) / sqrt(3.0)) * 100.0)
        var points = 100 - difference

        let msg: String
        if difference == 0 {
          msg = "Perfect!"
          points += 100
        } else if difference < 5 {
          msg = "You almost had it!"
          if difference == 1 {
            points += 50
          }
        } else if difference < 10 {
          msg = "Pretty good!"
        } else {
          msg = "Not even close..."
        }
        
        score += points
        
        return RoundResult(msg, points)
    }
    
    func startNewRound() {
        round += 1
        targetValue = RGB(r: Int.random(in: 0...255), g: Int.random(in: 0...255), b: Int.random(in: 0...255))
    }
    
    func reset() {
        score = 0
        round = 0
        startNewRound()
    }
}
