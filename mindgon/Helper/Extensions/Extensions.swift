//
//  Extensions.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit


extension String {
    
    var localized: String {
        
        return NSLocalizedString(self, comment: "")
        
    }
    
}


//MARK: -

extension Array {
    
    subscript (safe index: Int) -> Element? {
        
        if index < count && index >= 0 {
            
            return self[index]
            
        }
        
        return nil
        
    }
    
}

//MARK: -

extension SKLabelNode {
    
    func getDeltaTime(forGoal goal: CGFloat, maxDistance: CGFloat) -> TimeInterval {
        
        return TimeInterval(abs(goal - position.y) / maxDistance * 0.5)
        
    }
    
}

