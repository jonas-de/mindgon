//
//  GameScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: Scene {

    //MARK: - Attributes
    
    ///The current score
    /// - 1 point for every removed node
    var score: Int = 0
    
    ///The highest score achieved for this mode
    var highscore: Int = 0
    
    ///The current state of the game
    var state: GameState = .running
    
    ///Determines wheter the startnode is touched
    var starttouch: UITouch?
    
    
    //MARK: - Nodes
    var startbanner: StartBanner!
    
    var pausebtn: SKSpriteNode!
    
    var scorelabel: SKLabelNode!
    
    
    //MARK: - Textures
    
    let pausetexture = SKTexture(imageNamed: "pauseicon")
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //setupstartbanner()
        setupbuttons()
        setuplabels()
    }
    
    
    //MARK: - Custom initializer
    
    /// Creates the banner that is tapped to start the game
    func setupstartbanner() {
        startbanner = StartBanner(scene: self)
        addChild(startbanner)
    }
    
    /// Setup the pausebutton
    func setupbuttons() {
        let pausefactor: CGFloat = 0.12
        pausebtn = SKSpriteNode(texture: pausetexture,
                                      color: .clear,
                                      size: CGSize(width: safeFrame.width * pausefactor,
                                                   height: safeFrame.width * pausefactor))
        pausebtn.position = CGPoint(x: safeFrame.maxX - safeFrame.width * pausefactor * 0.5,
                                          y: safeFrame.maxY - safeFrame.width * pausefactor * 0.5)
        pausebtn.alpha = 0
    }
    
    /// Setup the labels
    func setuplabels() {
        
        //Scorelabel
        scorelabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        scorelabel.horizontalAlignmentMode = .left
        scorelabel.verticalAlignmentMode = .center
        scorelabel.fontColor = .white
        scorelabel.fontSize = safeFrame.width * 0.16
        scorelabel.position = CGPoint(x: safeFrame.minX, y: safeFrame.maxY - safeFrame.width * 0.059)
        scorelabel.text = "0"
        scorelabel.alpha = 0
    }
    
    //MARK: - Custom functions
    
    /// the function that starts the game
    /// - Needs to be overwritten
    func startgame() {
        state = .running
        addChild(pausebtn)
        pausebtn.run(SKAction(named: "appear")!)
        addChild(scorelabel)
        scorelabel.run(SKAction(named: "appear")!)
    }
    
    
    //MARK: - Handle touches
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
        }
    }
 */
}
