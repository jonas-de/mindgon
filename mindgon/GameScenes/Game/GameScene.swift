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
        safeframe = self.getsafearea()
        
        setupstartbanner()
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
                                      size: CGSize(width: safeframe.width * pausefactor,
                                                   height: safeframe.width * pausefactor))
        pausebtn.position = CGPoint(x: safeframe.maxX - safeframe.width * pausefactor * 0.5,
                                          y: safeframe.maxY - safeframe.width * pausefactor * 0.5)
        pausebtn.alpha = 0
    }
    
    /// Setup the labels
    func setuplabels() {
        
        //Scorelabel
        scorelabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        scorelabel.horizontalAlignmentMode = .left
        scorelabel.verticalAlignmentMode = .center
        scorelabel.fontColor = .white
        scorelabel.fontSize = safeframe.width * 0.16
        scorelabel.position = CGPoint(x: safeframe.minX, y: safeframe.maxY - safeframe.width * 0.059)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            
            //touches at the startbutton (only recognized if not already touched)
            if (state == .start && starttouch == nil && startbanner.contains(loc)) {
                starttouch = touch
                
                startbanner.run(SKAction.scale(to: 1.1, duration: 0.08))
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            
            
            if (state == .start) {
                //handles touches when the startbutton is touched
                if (starttouch != nil && state == .start) {
                    if (touch === starttouch) {
                        
                        if (startbanner.contains(loc)){
                            // closes the button and starts the game
                            starttouch = nil
                            
                            startbanner.close()
                            
                            let zeroheight = SKAction.scaleY(to: 0, duration: 0.1)
                            zeroheight.timingMode = .easeOut
                            startbanner.run(zeroheight)
                            
                            startgame()
                        } else {
                            //end the touch but do not start the game
                            starttouch = nil
                            startbanner.run(SKAction.scale(to: 1, duration: 0.08))
                        }
                    }
                }
            }
            
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (state == .start) {
                if(touch === starttouch) {
                    //cancel the starttouch
                    starttouch = nil
                    startbanner.run(SKAction.scale(to: 1, duration: 0.08))
                }
            }
        }
    }
    
    //MARK: - Debug
    
    func showsafeframe(){
        let safenode = SKShapeNode(rect: self.safeframe)
        safenode.fillColor = .red
        safenode.strokeColor = .white
        addChild(safenode)
    }
    
}
