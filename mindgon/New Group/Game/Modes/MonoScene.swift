//
//  MonoScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class MonoScene: GameScene {
    
    let color: UIColor = GameHelper.randomColor()

    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        gameType = .monochrom
        
        super.didMove(to: view)
        
    }
    
    //MARK: - Custom
    
    /**
     Creates a node to fill the bounding node with the same color
     - Parameter node: The bounding node
     */
    override func fillNode(inNode node: SKSpriteNode){
        
        //TODO: Other shapes
        let fillNode = SKShapeNode(ellipseIn: CGRect(x: -node.size.width/2,
                                                     y: -node.size.width/2,
                                                     width: node.size.width,
                                                     height: node.size.height))
        
        fillNode.fillColor = color
        fillNode.strokeColor = .white
        fillNode.lineWidth = nodeSize * 0.02
        fillNode.name = "fill"
        
        node.addChild(fillNode)
        
    }
    
    
    
}
