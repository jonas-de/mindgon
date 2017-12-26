//
//  Helper.swift
//  mindgon
//
//  Created by Jonas Andersson on 25.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit


struct Values {
    
    ///The minimum distance between content and the rim of the display
    static let mininset: CGFloat = 10
    
    ///The size of the lightmodeswitch
    static let lightmodesize: CGFloat = 60
    
    ///The size of the settingsbutton
    static let settingsbtnsize: CGFloat = 65
    
    ///The width of the gamemodecards
    static let cardwith: CGFloat = 600
    
    
}


extension SKScene {
    
    func getsafearea() -> CGRect{
        
        let origin = self.convertPoint(toView: CGPoint(x: 0, y: 0))
        var ins = self.view!.safeAreaInsets
        if (ins.left < Values.mininset){
            ins.left = Values.mininset
        }
        if (ins.right < Values.mininset){
            ins.right = Values.mininset
        }
        if (ins.top < Values.mininset){
            ins.top = Values.mininset
        }
        if (ins.bottom < Values.mininset){
            ins.bottom = Values.mininset
        }
        let saferectanchor = CGPoint(x: self.convertPoint(fromView: CGPoint(x: ins.left, y: origin.y)).x,
                                     y: self.convertPoint(fromView: CGPoint(x: origin.x, y: ins.top)).y)
        let saferectanchorinsets = CGPoint(x: self.convertPoint(fromView: CGPoint(x: view!.frame.width - ins.right, y: origin.y)).x,
                                           y: self.convertPoint(fromView: CGPoint(x: origin.x, y: view!.frame.height - ins.bottom)).y)
        return CGRect(x: saferectanchor.x,
                      y: saferectanchor.y,
                      width: saferectanchorinsets.x - saferectanchor.x,
                      height: saferectanchorinsets.y - saferectanchor.y)
    }
}
public extension CGFloat {
    
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    /// Random CGFloat between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

