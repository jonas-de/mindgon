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

    
//MARK: - General attributes
    
    ///The type of the game
    var gameType = GameType.normal
    
    ///The current state of the game
    var state: GameState = .running
    

//MARK: - Game attributes
    
    ///The current score (one point for every removed node)
    var score: Int = 0
    
    ///The highest score achieved in this mode
    var highscore: Int = 0
    
    ///The state of the first node
    var firstNodeState = NodeState.untouched
    
    ///The currently touched node
    var touchedNode: TouchedNode = .no
    
    ///Determines wether the nodes are currently reduced to one node
    var reducingToOneRunning: Bool = false
    
    ///The price for reviving
    var revivePrice: Int = 10
    
    ///Determines wheter nodes are currently highlighted after reviving
    var highlightingState = HighlightingState.stop
    
//MARK: - Settings attributes
    
    ///a Bool indicating wether the device should give haptical feedback
    var shouldVibrate: Bool = false
    
    
//MARK: - View attributes
    
    ///The computed size of the nodes
    var nodeSize: CGFloat = 0
    
    
//MARK: - Nodes
    
    ///A label to show the user his current score, changes its color when a new highscore is reached
    let scoreLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    
    var firstNode: SKSpriteNode!
    
    var nodes = [SKSpriteNode]()
    
    let heart = SKSpriteNode(imageNamed: "heart")
    
    let heartOutline = SKSpriteNode(imageNamed: "heartoutline")
    
    var pricingLabel: DiamondsLabel!
    
    let dontReviveLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .thin))
    
    
//MARK: - Device interaction
    
    ///A generator to give the user `Notification`-feedback if enabled
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    ///A generator to give the user `Impact`-feedback if enabled
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    
//MARK: - Start
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        highscore = UserDefaults.standard.integer(forKey: "\(gameType.id)highscore")
        
        nodeSize = getFactor(0.15, max: 60)
        
         shouldVibrate = UserDefaults.standard.bool(forKey: "settingsvibration")
        
        initializeScoreLabel()
        initializeReviveShapes()
        

        
        start()
        appearNodes()
        
    }
    
    ///called by the scene to start the game
    func start() {
        
        addNode()
        firstNode = nodes.removeFirst()
        let defs = UserDefaults.standard
        defs.set(false, forKey: "\(gameType.id)newhighscore")
        defs.set(0, forKey: "\(gameType.id)reduce")
        
    }
    
    ///triggers the animation of the main UI in the scene
    func appearNodes() {
        
        scoreLabel.run(SKAction(named: "appear")!)
        
    }
    
    
//MARK: - Functions for nodes
    
    //MARK: Add nodes
    
    /**
     Adds a new node to the list and therefore it calls all necessary functions and checks that there isn't any intersection at the randomly created position.
    */
    private func addNode() {
        
        let newNode = createNode()
        fillNode(inNode: newNode)
        
        
        var positionCounter = 0
        
        repeat {
            
            newNode.position = GameHelper.randomPoint(safeFrame, forSize: nodeSize)
            positionCounter += 1
            
            if positionCounter >= 10_000 {
                
                reduceNodesToOne()
                return
                
            }
            
        } while checkIntersection(newNode)
        
        
        nodes.append(newNode)
        
        addChild(newNode)
        newNode.run(SKAction(named: "appear")!)
        
    }
    
    /**
     Creates a new node that can be filled
     - Returns: the fillable node
    */
    private func createNode() -> SKSpriteNode {
        
        let newNode = SKSpriteNode(texture: nil,
                                   color: .clear,
                                   size: CGSize(width: nodeSize,
                                                height: nodeSize))
        
        
        newNode.alpha = 0
        
        return newNode
        
    }
    
    /**
     Creates a node to fill the bounding node
     - Parameter node: The bounding node
    */
    func fillNode(inNode node: SKSpriteNode){
        
        //TODO: Other shapes
        let fillNode = SKShapeNode(ellipseIn: CGRect(x: -node.size.width/2,
                                                     y: -node.size.width/2,
                                                     width: node.size.width,
                                                     height: node.size.height))
        
        fillNode.fillColor = GameHelper.randomColor()
        fillNode.strokeColor = fillNode.fillColor
        fillNode.lineWidth = nodeSize * 0.01
        fillNode.isAntialiased = true
        fillNode.name = "fill"
        
        node.addChild(fillNode)
        
    }
    
    
    /**
     Checks if the new node intersects with any other node plus some extra insets
     - Parameter node: the checked node
     - Returns: a Bool indicating wether there is any intersection
    */
    private func checkIntersection(_ node: SKSpriteNode) -> Bool {
        
        let insetFactor = -getFactor(0.02, max: 15)
        
        
        func checkScoreLabel() -> Bool {
            
            let scoreLabelIntersection = SKShapeNode(rect: scoreLabel.frame.insetBy(dx: insetFactor,
                                                                                    dy: insetFactor))
            
            return node.intersects(scoreLabelIntersection)
            
        }
        
        func checkFirstNode() -> Bool {
            
            if let n = firstNode {
                
                let firstNodeIntersection = SKShapeNode(rect: n.frame.insetBy(dx: insetFactor,
                                                                              dy: insetFactor))
                
                return node.intersects(firstNodeIntersection)
                
            }
            
            return false
            
        }
        
        
        func checkNodes() -> Bool {
            
            for n in nodes {
                
                let nodeintersection = SKShapeNode(rect: n.frame.insetBy(dx: insetFactor,
                                                                         dy: insetFactor))
                
                if node.intersects(nodeintersection) { return true }
                
            }
            
            return false
            
        }
        
        return checkScoreLabel() || checkFirstNode() || checkNodes()
        
    }
    
    
    //MARK: Node touches
    
    func tappedfirstnode() {
        
        addNode()
        
        if !reducingToOneRunning {
            
            if firstNodeState == .untouched {
                
                if let fill = firstNode.childNode(withName: "fill") as! SKShapeNode? {
                    
                    fill.fillColor = .white
                }
                
                firstNode.run(SKAction.scale(to: 1, duration: 0.1))
                
                firstNodeState = .touched
                
            } else {
                firstNode.name = "removeold"
                firstNode.run(SKAction.fadeOut(withDuration: 0.1), completion: {
                    
                    if let node = self.childNode(withName: "removeold") {
                        
                        node.removeFromParent()
                        
                    }
                    
                })
                
                firstNodeState = .untouched
                
                firstNode = nodes.removeFirst()
                
                updatescore()
                
            }
            
        }
        
    }
    
    func endForRevive() {
        
        state = .preparerevive
        
        self.focus.run(SKAction.fadeAlpha(to: 0.9, duration: 0.5), completion: {
            
            appearReviveShapes()
            
        })
        
        func appearReviveShapes() {
            
            
            heartOutline.run(SKAction(named: "appear")!)
            
            let appearAnimation = SKAction.sequence([SKAction.wait(forDuration: 0.35),
                                                    SKAction(named: "appear")!])
            
            dontReviveLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                   SKAction.fadeIn(withDuration: 0.2)]))
            
            heart.run(appearAnimation, completion: {
                
                canRevive()
                
            })
            
        }
        
        func canRevive() {
            
            
            let reviveTime = 5.0
            
            state = .revive
            
            let scaleToZero = SKAction.scale(to: 0, duration: reviveTime - 0.2)
            scaleToZero.timingMode = .easeIn
            
            let scaleHeart = SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                                scaleToZero])
            
            heart.run(scaleHeart, completion: {
                
                endRevive()
                
            })
            
        }
        
        func endRevive() {
            
            
            let heartDisappearAnimation = SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                                             SKAction.wait(forDuration: 0.25)])
            
            dontReviveLabel.run(SKAction(named: "disappear")!)
            heartOutline.run(heartDisappearAnimation, completion: {
                
                self.endGame()
                
            })
            
            
        }
        
        
    }
    
    func didRevive() {
        
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "points") - revivePrice, forKey: "points")
        
        if revivePrice == 10 {
            
            revivePrice = 20
            
        } else {
            
            revivePrice += 20
            
        }
        
        let disappearAnimation = SKAction(named: "disappear")!
        heartOutline.removeAllActions()
        heartOutline.run(disappearAnimation)
        
        heart.removeAllActions()
        heart.run(disappearAnimation)
        
        dontReviveLabel.removeAllActions()
        dontReviveLabel.run(SKAction.fadeOut(withDuration: 0.2), completion: {
            
            handleEndAnimations()
            self.showNodesInRow()
        
        })
        
        func handleEndAnimations() {
            
            state = .running
            
            dontReviveLabel.removeFromParent()
            heartOutline.removeFromParent()
            heart.removeFromParent()
            
            if let pricingLabelNode = heart.childNode(withName: "pricinglabel") {
                
                pricingLabelNode.removeFromParent()
                
            }
            
            focus.removeAllActions()
            focus.run(SKAction.fadeOut(withDuration: 0.2))
            
            initializeReviveShapes()
            
        }
        
    }
    
    func showNodesInRow() {
        
        let bigger = SKAction.scale(to: 1.25, duration: 0.2)
        bigger.timingMode = .easeOut
        
        let smaller = SKAction.scale(to: 1, duration: 0.2)
        smaller.timingMode = .easeIn
        
        
        let highlight = SKAction.sequence([bigger, smaller])
        
        highlightingState = .running
        
        firstNode.run(highlight)
        
        func highlightnode(atIndex index: Int) {
            
            if index >= 0 && index < nodes.count  && highlightingState == .running{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(600), execute: {
                    
                    self.nodes[index].run(highlight)
                    highlightnode(atIndex: index + 1)
                    
                    
                })
                
            } else if index == nodes.count || highlightingState == .shouldStop{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(600), execute: {
                    
                    self.highlightingState = .stop
                    
                })
            }
        }
        
        highlightnode(atIndex: 0)
        
    }
    
    
    
    func didStoppedRevive() {
        
        let disappearAnimation = SKAction(named: "disappear")!
        print("tapped away")
        heart.removeAllActions()
        heart.run(disappearAnimation)
        
        heartOutline.removeAllActions()
        heart.run(disappearAnimation)
        
        dontReviveLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                               SKAction.wait(forDuration: 0.3)]),
                            completion: {
            
            self.endGame()
            
        })
        
    }
    
    func endGame() {
        
        let defs = UserDefaults.standard
        
        defs.set(score, forKey: "\(gameType.id)lastscore")
        defs.set(score, forKey: "addpoints")
        
        if score > highscore {
            
            defs.set(true, forKey: "\(gameType.id)newhighscore")
            defs.set(score, forKey: "\(gameType.id)highscore")
            
        }
        
        print(self.gameType)
        let data: [String: GameType] = ["gamesender" : self.gameType]
        
        NotificationCenter.default.post(name: .showmenu, object: self, userInfo: data)
        
    }
    
    
    //MARK: Other node functions
    
    private func reduceNodesToOne() {
        
        reducingToOneRunning = true
        
        let defs = UserDefaults.standard
        defs.set(defs.integer(forKey: "\(gameType.id)reduce") + 1, forKey: "\(gameType.id)reduce")
        
        let newFirstNode = nodes.removeFirst()
        
        func removeFirstNode() {
            
            firstNode.zPosition = newFirstNode.zPosition - 1
            firstNode.name = "removeold"
            
            let distance = hypot(Double(firstNode.position.x - newFirstNode.position.x),
                                 Double(firstNode.position.y - newFirstNode.position.y));
            
            let moveAction = SKAction.move(to: newFirstNode.position, duration: distance * 0.005)
            moveAction.timingMode = .easeIn
            
            firstNode = newFirstNode
            firstNodeState = .untouched
            
            if let oldFirstNode = childNode(withName: "removeold") {
                
                print("found old first node")
                
                oldFirstNode.run(moveAction, completion: {
                    
                    oldFirstNode.removeFromParent()
                    
                })
                
            }
            
        }
        
        func removeOtherNodes() {
            
            for node in nodes {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500), execute: {
                    
                    self.nodes.remove(at: 0)
                    
                    node.zPosition = self.firstNode.zPosition - 1
                    
                    let distance = hypot(Double(node.position.x - self.firstNode.position.x),
                                         Double(node.position.y - self.firstNode.position.y));
                    
                    let moveAction = SKAction.move(to: self.firstNode.position, duration: distance * 0.005)
                    moveAction.timingMode = .easeIn
                    
                    node.run(moveAction, completion: {
                        
                        
                        node.removeFromParent()
                        
                        if (self.nodes.count == 0) {
                            
                            self.reducingToOneRunning = false
                            
                        }
                        
                    })
                    
                })
                
            }
            
        }
        
        removeFirstNode()
        removeOtherNodes()
        
    }
    
    
    
    
    //MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        prepareFeedback(type: .impact)
        prepareFeedback(type: .wrong)
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //Touches when the game is runnung
            if state == .running {
                
                if highlightingState == .running {
                    
                    highlightingState = .shouldStop
                    
                }
                
                
                if touchedNode == .no {
                    
                    if firstNode.contains(location) {
                        
                        touchedNode = TouchedNode.firstNode(touch: touch)
                        firstNode.run(SKAction.scale(to: 0.9, duration: 0.1))
                        
                    }
                    
                    for (index, node) in nodes.enumerated() {
                        
                        if node.contains(location) {
                            
                            touchedNode = .node(index: index, touch: touch)
                            node.run(SKAction.scale(to: 0.9, duration: 0.1))
                            
                        }
                    }
                }
                
            } else if state == .revive {
                
                if heartOutline.contains(location) {
                    
                    heart.removeAllActions()
                    
                    if UserDefaults.standard.integer(forKey: "points") >= revivePrice {
                        
                         didRevive()
                        
                    }
                    
                } else {
                    
                    didStoppedRevive()
                    
                }
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if state == .running {
                
                func checkFirstNodeTouch() {
                    
                    if touchedNode == .firstNode(touch: touch) {
                        
                        if firstNode.contains(location) {
                            
                            tappedfirstnode()
                            giveFeedback(type: .impact)
                            
                        } else {
                            
                            firstNode.run(SKAction.scale(to: 1, duration: 0.1))
                            
                        }
                        
                    }
                    
                }
                
                func checkWrongNodeTouch() {
                    
                    if touchedNode == TouchedNode.aNode(touch: touch) {
                        
                        if let node = nodes[safe: touchedNode.getIndex()] {
                            
                            if node.contains(location) {
                                
                                giveFeedback(type: .wrong)
                                endForRevive()
                                
                            }
                            
                            node.run(SKAction.scale(to: 1, duration: 0.1))
                            
                        }
                        
                    }
                    
                }
                
                checkFirstNodeTouch()
                checkWrongNodeTouch()
                
                touchedNode = .no
                
            }
            
        }
        
    }
    
    
    
    
    //MARK: - Custom initializer
    
    /// Initializes the shapes that are used to revive after a loss
    func initializeReviveShapes() {
        
        func initializeHeartOutline() {
            
            heartOutline.size = CGSize(width: getFactor(0.8, max: 1000),
                                       height: getFactor(0.8, max: 1000))
            heartOutline.position = CGPoint(x: safeFrame.midX,
                                            y: safeFrame.midY + getFactor(0.15, max: 1000))
            heartOutline.zPosition = 10
            heartOutline.alpha = 0
            
            addChild(heartOutline)
            
        }
        
        func initializeHeart() {
            
            heart.size = CGSize(width: getFactor(0.6, max: 1000),
                                height: getFactor(0.6, max: 1000))
            heart.position = CGPoint(x: safeFrame.midX,
                                     y: safeFrame.midY + getFactor(0.15, max: 1000))
            heart.zPosition = 10
            heart.alpha = 0
            
            addChild(heart)
            
        }
        
        func initializePricingLabel() {
            
            pricingLabel = DiamondsLabel(inScene: self, value: revivePrice, sizeFactor: 0.15)
            pricingLabel.name = "pricinglabel"
            pricingLabel.position = CGPoint(x: 0, y: 0.05 * heart.size.width)
            heart.addChild(pricingLabel)
            
        }
        
        func initializeDontReviveLabel() {
            
            dontReviveLabel.fontSize = getFactor(0.1, max: 1000)
            dontReviveLabel.text = "dontrevive".localized
            dontReviveLabel.horizontalAlignmentMode = .center
            dontReviveLabel.verticalAlignmentMode = .top
            
            dontReviveLabel.zPosition = 10
            dontReviveLabel.position = CGPoint(x: safeFrame.midX,
                                               y: safeFrame.midY - getFactor(0.3, max: 1000))
            
            dontReviveLabel.alpha = 0
            
            addChild(dontReviveLabel)
            
        }
        
        
        initializeHeartOutline()
        initializeHeart()
        initializePricingLabel()
        initializeDontReviveLabel()
        
    }
    
    
    /// Initializes the score label
    func initializeScoreLabel() {
        
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = getFactor(0.16, max: 120)
        scoreLabel.text = "0"
        
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: safeFrame.minX,
                                      y: safeFrame.maxY - getFactor(0.01, max: 25))
        
        scoreLabel.alpha = 0
        
        addChild(scoreLabel)
        
    }
    
    private func updatescore() {
        
        score += 1
        
        scoreLabel.text = "\(score)"
        
        if score > highscore {
            
            scoreLabel.fontColor = UIColor(named: "newhighcolor") ?? .orange
            
        }
        
    }
    
    
    //MARK: - Feedback
    
    /**
     Prepares the FeedbackGenerator
     - Parameter type: the type of the feedback
    */
    func prepareFeedback(type: FeedbackType) {
        
        if shouldVibrate {
            
            switch type {
                
            case .impact:
                
                impactFeedbackGenerator.prepare()
                
            case .wrong:
                
                notificationFeedbackGenerator.prepare()
                
            }
            
        }
        
    }
    
    /**
     creates feedback
     - Parameter type: the type of the feedback
     */
    func giveFeedback(type: FeedbackType) {
        
        if shouldVibrate {
            
            switch type {
                
            case .impact:
                
                impactFeedbackGenerator.impactOccurred()
                
            case .wrong:
                
                notificationFeedbackGenerator.notificationOccurred(.error)
                
            }
            
        }
        
    }
    
}
