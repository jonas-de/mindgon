//
//  MenuTouch.swift
//  mindgon
//
//  Created by Jonas Andersson on 29.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit

class MenuTouch{

    
    //MARK: - Attributes
    
    let touch: UITouch
    
    let origin: CGPoint
    
    
    //MARK: - Initializer
    
    init(_ touch: UITouch, from origin: CGPoint) {
        
        self.touch = touch
        self.origin = origin
        
    }
    
    /*
     - Parameter location: The location of the touch when releasing it
     - Returns: A type of SwipeDirection
    */
    func getSwipeDirection(newlocation location: CGPoint) -> SwipeDirection {
        
        if location.x > origin.x + 75 {
            
            return .right
            
        }
        
        if location.x < origin.x - 75 {
            
            return .left
            
        }
        
        return .noSwipe
        
    }
    
}
