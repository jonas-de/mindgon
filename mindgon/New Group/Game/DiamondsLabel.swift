//
//  RevivePricingLabel.swift
//  mindgon
//
//  Created by Jonas Andersson on 22.04.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class DiamondsLabel: SKSpriteNode {
    
    var diamond: SKSpriteNode
    var text: SKLabelNode
    
    init(inScene scene: Scene, value: Int, sizeFactor: CGFloat) {
        
        diamond = SKSpriteNode(texture: SKTexture(imageNamed: "diamond"),
                                   color: .clear,
                                   size: CGSize(width: scene.getFactor(sizeFactor, max: 1000),
                                                height: scene.getFactor(sizeFactor, max: 1000)))
        
        text = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .medium))
        
        
        text.fontSize = scene.getFactor(sizeFactor, max: 1000)
        text.text = String(value)
        
        text.horizontalAlignmentMode = .left
        text.verticalAlignmentMode = .center
        
        
        let width = diamond.size.width + text.frame.width
        
        
        super.init(texture: nil, color: .clear,
                   size: CGSize(width: width, height: text.fontSize))
        
        
        diamond.anchorPoint = CGPoint(x: 0, y: 0.5)
        diamond.position = CGPoint(x: -0.5 * size.width, y: 0)
        
        self.addChild(diamond)
        
        
        text.position = CGPoint(x: -0.5 * width + diamond.size.width, y: 0)
        
        addChild(text)
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(value: Int) {
        
        text.text = String(value)
        
    }
    
    
    
    
}
