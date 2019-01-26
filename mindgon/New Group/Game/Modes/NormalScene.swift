//
//  NormalScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class NormalScene: GameScene {
    
    
//MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        gameType = .normal
        
        super.didMove(to: view)
        
    }
    
}
