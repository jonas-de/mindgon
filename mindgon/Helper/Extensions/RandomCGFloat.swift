//
//  RandomCGFloat.swift
//  mindgon
//
//  Created by Jonas Andersson on 30.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit


extension CGFloat {
    
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
        
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    /**
     Random CGFloat between 0 and n-1
     - Parameter min:
     - Parameter max:
     - Returns: Returns a random CGFloat point number between 0 and n max
     */
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.random * (max - min) + min
        
    }
    
}
