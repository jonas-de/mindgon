//
//  StartBanner.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class StartBanner: SKSpriteNode {

    var background: SKShapeNode!
    var texttopline: SKLabelNode!
    var textlowline: SKLabelNode!
    
    
    init(scene: GameScene) {
        
        super.init(texture: nil, color: .clear, size: CGSize(width: scene.size.width,
                                                           height: scene.size.width * 0.4))
        self.position = CGPoint(x: 0, y: -scene.size.width * 0.2)
        
        
        //Background
        background = SKShapeNode(rect: CGRect(x: -scene.size.width / 2,
                                              y: -scene.size.width * 0.2,
                                              width: self.size.width,
                                              height: self.size.height))
        background.strokeColor = .clear
        background.fillColor = .red
        background.alpha = 0.5
        self.addChild(background)
        
        //Text
        texttopline = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        texttopline.fontColor = .white
        texttopline.fontSize = scene.size.width * 0.125
        texttopline.verticalAlignmentMode = .center
        texttopline.horizontalAlignmentMode = .center
        
        textlowline = texttopline.copy() as! SKLabelNode
        
        texttopline.position = CGPoint(x: 0, y: scene.size.width * 0.08)
        texttopline.text = "TIPPEN ZUM"
        
        textlowline.position = CGPoint(x: 0, y: -scene.size.width * 0.08)
        textlowline.text = "STARTEN"
        
        addChild(texttopline)
        addChild(textlowline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func close() {        
        let fadeout = SKAction.fadeOut(withDuration: 0.05)
        fadeout.timingMode = .easeOut
        
        texttopline.run(fadeout)
        textlowline.run(fadeout)
    }
    
    
    
}
