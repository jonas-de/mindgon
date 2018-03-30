//
//  NormalScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class NormalScene: GameScene {

    //MARK: - Attributes
    let gametyp: GameType = .normal
    
    let nodesizefactor: CGFloat = 0.15
    
    var firstnode: SKSpriteNode!
    var firstnodestate: NodeState!
    var nodetouch: UITouch?
    var touchednode: Int = -2
    
    //MARK: - Nodes
    
    var nodes: [SKSpriteNode] = []
    
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        highscore = UserDefaults.standard.integer(forKey: "\(gametyp.id)highscore")
        startgame()
        
    }
    
    override func startgame() {
        super.startgame()
        
        addnode()
        firstnode = nodes.removeFirst()
        firstnodestate = .untouched

    }
    
    //MARK: - Custom initializer
    
    
    //MARK: - Custom functions
    private func addnode() {
        
        let newnode = createnode()
        newnode.position = GameHelper.randompoint(safeFrame, forfactor: nodesizefactor)
        
        var tries = 0
        while(checkintersection(newnode)){
            tries += 1
            newnode.position = GameHelper.randompoint(safeFrame, forfactor: nodesizefactor)
            
            if tries >= 50000 {
                break
            }
        }
        if tries >= 50000 {
            reducetoone()
        }
        addChild(newnode)
        newnode.run(SKAction(named: "appear")!)
        nodes.append(newnode)
    }
    
    private func createnode() -> SKSpriteNode {
        
        let newnode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: safeFrame.width * nodesizefactor,
                                                                            height: safeFrame.width * nodesizefactor))
        /*
        let fillnode = SKShapeNode(rect: CGRect(x: -newnode.size.width/2,
                                                y: -newnode.size.width/2,
                                                width: newnode.size.width,
                                                height: newnode.size.height))
 */
        let fillnode = SKShapeNode(ellipseIn: CGRect(x: -newnode.size.width/2,
                                                     y: -newnode.size.width/2,
                                                     width: newnode.size.width,
                                                     height: newnode.size.height))
        fillnode.fillColor = GameHelper.randomcolor()
        fillnode.lineWidth = safeFrame.width * nodesizefactor * 0.02
        fillnode.strokeColor = .white
        fillnode.name = "fill"
        newnode.addChild(fillnode)
        newnode.alpha = 0
        return newnode
    }
    
    private func checkintersection(_ node: SKSpriteNode) -> Bool {
        
        if(node.intersects(scorelabel)){
            return true
        }
        
        
        let insetfactor: CGFloat = { ()->CGFloat in
            var i: CGFloat = -self.safeFrame.width * 0.01
            if i < -20 {
                i = -20
            }
            return i
        }()
        
        if let n = firstnode {
            let firstnodeintersection = SKShapeNode(rect: n.frame.insetBy(dx: insetfactor,
                                                                          dy: insetfactor))
            if node.intersects(firstnodeintersection) {
                return true
            }
        }
        
        let pausebuttonintersection = SKShapeNode(rect: pausebtn.frame.insetBy(dx: insetfactor,
                                                                               dy: insetfactor))
        
        if(node.intersects(pausebuttonintersection)){
            return true
        }
        
        for n in nodes {
            print(n.frame)
            let nodeintersection = SKShapeNode(rect: n.frame.insetBy(dx: insetfactor,
                                                                     dy: insetfactor))
            print(nodeintersection.frame)
            if(node.intersects(nodeintersection)){
                return true
            }
        }
        return false
    }
    
    private func updatescore() {
        
        score += 1
        scorelabel.text = "\(score)"
        
        if (score > highscore) {
            scorelabel.fontColor = #colorLiteral(red: 0.9607843137, green: 0.8039215686, blue: 0.2745098039, alpha: 1)
        }
        
    }
    
    private func reducetoone() {
        
    }
    
    private func touchedwrongnode(index i: Int) {
        
    }
    
    
    //MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let loc = touch.location(in: self)
            
            //Touches when the game is runnung
            if (state == .running) {
                
                if (firstnode.contains(loc) && nodetouch == nil && touchednode == -2) {
                    
                    nodetouch = touch
                    touchednode = -1
                    firstnode.run(SKAction.scale(to: 0.9, duration: 0.1))
                    
                }
                
                for (index, node) in nodes.enumerated() {
                    
                    if(node.contains(loc) && nodetouch == nil && touchednode == -2) {
                        nodetouch = touch
                        touchednode = index
                        
                        node.run(SKAction.scale(to: 0.9, duration: 0.1))
                    }
        
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            
            if (state == .running) {
                let loc = touch.location(in: self)
                
                if(nodetouch != nil){
                    
                    if(touch === nodetouch){
                    
                        if(firstnode.contains(loc) && touchednode == -1){
                        
                            if(firstnodestate == .untouched){
                                
                                firstnode.run(SKAction.scale(to: 1, duration: 0.1))
                                
                            } else {
                                
                                firstnode.run(SKAction.fadeOut(withDuration: 0.1))
                            
                            }
                            
                            tappedfirstnode()
                        
                        } else if (touchednode == -1){
                        
                            firstnode.run(SKAction.scale(to: 1, duration: 0.1))
                        
                        } else {
                            
                            if (nodes[touchednode].contains(loc)) {
                                touchedwrongnode(index: touchednode)
                                nodes[touchednode].run(SKAction.scale(to: 1, duration: 0.1))
                            } else {
                                nodes[touchednode].run(SKAction.scale(to: 1, duration: 0.1))
                            }
                        }
                        touchednode = -2
                        nodetouch = nil
                        
                    }
                }
            }
            
        }
    }
    
    private func tappedfirstnode() {
        if(firstnodestate == .untouched){
            addnode()
            if let fill = firstnode.childNode(withName: "fill") as! SKShapeNode? {
                fill.fillColor = .white
            }
            firstnodestate = .touched
        } else {
            addnode()
            firstnodestate = .untouched
            firstnode = nodes.removeFirst()
            updatescore()
        }
        
    }
    
    
}
