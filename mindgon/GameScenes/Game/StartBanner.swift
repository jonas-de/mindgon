//
//  StartBanner.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class StartBanner: SKShapeNode {

    var background: SKShapeNode!
    var texttopline: SKLabelNode!
    var textlowline: SKLabelNode!
    var touched: Bool!
    
    
    init(scene: GameScene) {
        super.init()
        
        self.path = CGPath(rect: CGRect(x: -0.5 * scene.size.width,
                                        y: -scene.size.width * 0.4,
                                        width: scene.size.width,
                                        height: scene.size.width * 0.4),
                           transform: nil)
        self.strokeColor = .clear
        self.fillColor = .clear
        
        touched = false
        
        //Background
        background = SKShapeNode(path: self.path!)
        background.position = .zero
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
        
        texttopline.position = CGPoint(x: 0, y: -scene.size.width * 0.12)
        texttopline.text = "TIPPEN ZUM"
        
        textlowline.position = CGPoint(x: 0, y: -scene.size.width * 0.28)
        textlowline.text = "STARTEN"
        
        addChild(texttopline)
        addChild(textlowline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
