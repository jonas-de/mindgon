//
//  GameHelper.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit




class GameHelper {
    
    //Colors to fill the nodes
    static let colors: [UIColor] = [UIColor(red: 1, green: 0, blue: 0, alpha: 1),   //rot
                                  UIColor(red: 1, green: 0.5, blue: 0, alpha: 1),   //orange
                                  UIColor(red: 1, green: 1, blue: 0, alpha: 1),     //gelb
                                  UIColor(red: 0.5, green: 1, blue: 0, alpha: 1),   //grün-gelb
                                  UIColor(red: 0, green: 1, blue: 0, alpha: 1),     //grün
                                  UIColor(red: 0, green: 1, blue: 0.5, alpha: 1),   //minz-grün
                                  UIColor(red: 0, green: 1, blue: 1, alpha: 1),     //blau-grün-türkis
                                  UIColor(red: 0, green: 0.5, blue: 1, alpha: 1),   //hellblau
                                  UIColor(red: 0, green: 0, blue: 1, alpha: 1),     //blau
                                  UIColor(red: 0.5, green: 0, blue: 1, alpha: 1),   //violett
                                  UIColor(red: 1, green: 0, blue: 1, alpha: 1),     //pink
                                  UIColor(red: 1, green: 0, blue: 0.5, alpha: 1)]   //magenta
    
    /**
     - Returns: a random color from `colors`
    */
    static func randomColor() -> UIColor {
        
        let randomIndex: Int = Int(arc4random_uniform(UInt32(colors.count)))
        
        return colors[randomIndex]
        
    }
    
    /**
     - Parameter safeFrame: the frame in which the point should be
     - Parameter size: the size of the object that should be drawn safely in the safeFrame
     - Returns: a random point according to the conditions of the parameters
    */
    static func randomPoint(_ safeFrame: CGRect, forSize size: CGFloat) -> CGPoint {
        
        let x = CGFloat.random(min: safeFrame.minX + 0.5 * size,
                               max: safeFrame.maxX - 0.5 * size)
        
        let y = CGFloat.random(min: safeFrame.minY + 0.5 * size,
                               max: safeFrame.maxY - 0.5 * size)
        
        return CGPoint(x: x, y: y)
        
    }
    
}
