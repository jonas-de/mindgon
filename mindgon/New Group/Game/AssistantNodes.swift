//
//  AssistantNodes.swift
//  mindgon
//
//  Created by Jonas Andersson on 05.04.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class CustomCircleNode: SKShapeNode {
    
    let assistantNode = NumberNode()
    
    class NumberNode: SKNode {
        
        override var alpha: CGFloat {
            
            didSet(alpha) {
                
                print(alpha)
                
                if let parent = self.parent as? CustomCircleNode {
                    
                    print("didgetparent")
                    parent.angleFactor = alpha
                    
                }
                
            }
            
        }
        
    }
    
    var center: CGPoint
    
    var radius: CGFloat
    
    var angleFactor: CGFloat = 0 {
        
        didSet(factor) {
            
            print("new factor: \(factor)")
           setPath()
            
        }
        
        
    }
    
    
    //MARK: - Initializer
    
    init(center: CGPoint, radius: CGFloat) {
        
        self.center = center
        self.radius = radius
        
        
        
        super.init()
        
        addChild(assistantNode)
        
        alpha = 0.8
        
        strokeColor = .clear
        
        fillColor = .red
        
        assistantNode.alpha = 0
        
        setPath()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    //MARK: - Custom
    
    private func setPath() {
        
        path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: CGFloat.pi * -2 * angleFactor,
                            endAngle: CGFloat.pi * 2 * (0.5 + angleFactor),
                            clockwise: false).cgPath
        
    }
    
    func runChange(withDuration duration: TimeInterval) {
        
        assistantNode.run(SKAction.fadeAlpha(to: 0.25, duration: duration), completion: {
            
            print(self.assistantNode.alpha)
            
        })
        
    }
    
}
