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
    let defaultValue = 50
    var targetValue = 0
    var score = 0
    var round = 0
    
    func finishRound(with value: Int) -> RoundResult {
        let difference = abs(targetValue - value)
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
        targetValue = Int.random(in: 1...100)
    }
    
    func reset() {
        score = 0
        round = 0
        startNewRound()
    }
}
