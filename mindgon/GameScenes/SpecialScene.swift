//
//  SpecialScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class SpecialScene: GameScene {

    //MARK: - Attributes
    
    
    //MARK: - Nodes
    
    
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        highscore = UserDefaults.standard.integer(forKey: "specialhighscore")
        
    }
    
    //MARK: - Custom initializer
    
    
    
}
