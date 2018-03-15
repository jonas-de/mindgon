//
//  GameScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {

    //MARK: - Attributes
    
    ///The current score
    /// - 1 point for every removed node
    var score: Int = 0
    
    ///The highest score achieved for this mode
    var highscore: Int = 0
    
    ///The current state of the game
    var state: GameState = .start
    
    ///The area in which drawing can happen without intersection with System-UI
    var safeframe: CGRect!
    
    
    //MARK: - Nodes
    var startbanner: StartBanner!
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        safeframe = self.getsafearea()
        setupstartbanner()
    }
    
    //MARK: - Custom functions
    
    func setupstartbanner() {
        startbanner = StartBanner(scene: self)
        addChild(startbanner)
    }
    
    
}
