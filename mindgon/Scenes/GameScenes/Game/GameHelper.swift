//
//  GameHelper.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

enum NodeState: Int {
    case untouched, touched
}


class GameHelper {
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
    
    static func randomcolor() -> UIColor {
        let randomIndex: Int = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
    
    static func randompoint(_ safeframe: CGRect, forfactor f: CGFloat) -> CGPoint {
        
        let x: CGFloat = CGFloat(Double.random(min: Double(safeframe.minX + 0.5 * safeframe.width * f),
                                               max: Double(safeframe.maxX - 0.5 * safeframe.width * f)))
        
        let y: CGFloat = CGFloat(Double.random(min: Double(safeframe.minY + 0.5 * safeframe.width * f),
                                               max: Double(safeframe.maxY - 0.5 * safeframe.width * f)))
        
        return CGPoint(x: x, y: y)
    }
}

extension Double {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
    
}
