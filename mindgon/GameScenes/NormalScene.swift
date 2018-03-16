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
    let gametyp: GameTyp = .normal
    
    let nodesizefactor: CGFloat = 0.15
    
    var firstnode: SKSpriteNode!
    var firstnodestate: NodeState!
    var firstnodetouch: UITouch?
    
    //MARK: - Nodes
    
    var nodes: [SKSpriteNode] = []
    
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        highscore = UserDefaults.standard.integer(forKey: "\(Helper.getgametypid(typ: gametyp))highscore")
        
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
        newnode.position = GameHelper.randompoint(safeframe, forfactor: nodesizefactor)
        while(checkintersection(newnode)){
            newnode.position = GameHelper.randompoint(safeframe, forfactor: nodesizefactor)
        }
        addChild(newnode)
        nodes.append(newnode)
    }
    
    private func createnode() -> SKSpriteNode {
        
        let newnode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: safeframe.width * nodesizefactor,
                                                                             height: safeframe.width * nodesizefactor))
        let fillnode = SKShapeNode(rect: CGRect(x: -newnode.size.width/2,
                                                y: -newnode.size.width/2,
                                                width: newnode.size.width,
                                                height: newnode.size.height))
        fillnode.fillColor = GameHelper.randomcolor()
        fillnode.lineWidth = safeframe.width * 0.15 * 0.02
        fillnode.strokeColor = .white
        fillnode.name = "fill"
        newnode.addChild(fillnode)
        
        return newnode
    }
    
    private func checkintersection(_ node: SKSpriteNode) -> Bool {
        if(node.intersects(scorelabel)){
            return true
        }
        
        if let n = firstnode {
            if (node.intersects(n)){
                return true
            }
        }
        
        if(node.intersects(pausebtn)){
            return true
        }
        
        for n in nodes {
            if(node.intersects(n)){
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
    
    
    //MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            
            if (state == .running) {
                let loc = touch.location(in: self)
                if(firstnode.contains(loc) && firstnodetouch == nil) {
                    firstnodetouch = touch
                    
                    firstnode.run(SKAction.scale(to: 0.9, duration: 0.1))
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            
            if (state == .running) {
                let loc = touch.location(in: self)
                if(firstnodetouch != nil){
                    if(touch === firstnodetouch){
                        if(firstnode.contains(loc)){
                            if(firstnodestate == .untouched){
                                firstnode.run(SKAction.scale(to: 1, duration: 0.1))
                            } else {
                                firstnode.run(SKAction.fadeOut(withDuration: 0.1))
                            }
                            tappedfirstnode()
                        } else {
                            firstnode.run(SKAction.scale(to: 1, duration: 0.1))
                        }
                        firstnodetouch = nil
                        
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
