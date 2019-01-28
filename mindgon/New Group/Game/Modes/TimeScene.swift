//
//  TimeScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 15.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class TimeScene: GameScene {
    
    
    //MARK: - Attributes
    
    var timer: Timer!
    var remainingTime = 5
    
    override var highlightingState: HighlightingState {
       willSet (newValue) {
            if highlightingState == .running && (newValue == .shouldStop || newValue == .stop) && !timer.isValid{
                
                print("highlighting finished")
                initializeTimer()
                
            }
        }
    }
    
    var nodeCounter = 0
    
    var changingTimeState = ChangingTimeState.no
    
    let red = UIColor(named: "countdownred") ?? .red
    let yellow = UIColor(named: "countdownyellow") ?? .yellow
    let green = UIColor(named: "countdowngreen") ?? .green
    
    
    
    //MARK: - Nodes
    
    var currentTimeLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    var newTimeLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    /**
     Array with TimeLabels
     - 0: current
     - 1: new
    */
    let timeLabels = [SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold)), SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))]
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        gameType = .time
    
        
        super.didMove(to: view)
        
        initializeCurrentTimeLabel()
        initializeNewTimeLabel()
        addChild(newTimeLabel)
        
        self.run(SKAction.wait(forDuration: 0.25)) {
            self.initializeTimer()
        }
        
        
    }
    
    //MARK: - Timer
    
    private func initializeCurrentTimeLabel() {
        
        currentTimeLabel.horizontalAlignmentMode = .right
        currentTimeLabel.verticalAlignmentMode = .top
        
        currentTimeLabel.fontColor = getTimeColor()
        currentTimeLabel.fontSize = getFactor(0.16, max: 120)
        currentTimeLabel.text = String(remainingTime)
        
        currentTimeLabel.zPosition = 10
        currentTimeLabel.position = CGPoint(x: safeFrame.maxX,
                                            y: safeFrame.maxY - getFactor(0.01, max: 125))
        
        currentTimeLabel.alpha = 0
        
        addChild(currentTimeLabel)
        
        currentTimeLabel.run(SKAction(named: "appear")!)
        
    }
    
    
    private func initializeNewTimeLabel() {
        
        newTimeLabel.horizontalAlignmentMode = .right
        newTimeLabel.verticalAlignmentMode = .top
        newTimeLabel.fontColor = getTimeColor()
        newTimeLabel.fontSize = getFactor(0.16, max: 120)
        newTimeLabel.text = String(remainingTime)
        newTimeLabel.alpha = 0
        newTimeLabel.zPosition = 10
        newTimeLabel.position = CGPoint(x: safeFrame.maxX,
                                        y: safeFrame.maxY - getFactor(0.17, max: 125))
        
        
        
        
    }
    
    
    private func initializeTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
        log("Timer started")
        
    }
    
    @objc private func timerFired() {
        
        log("Timer fired")
        
        if remainingTime  == 0 {
            
            print("end Game (remainingTime = 0)")
            
            timer.invalidate()
            endForRevive()
            
        } else {
            changeTime(.decrease)
        }
        
        
    }
    
    private func changeTime(_ state: ChangingTimeState) {
        
        log("\(state) time - currently \(changingTimeState), \(remainingTime)s left")
        
        let goal = safeFrame.maxY
        let goalUp = goal + getFactor(0.17, max: 120)
        let goalDown = goal - getFactor(0.17, max: 120)
    
        func configureNewLabel(state: ChangingTimeState) {
            
            newTimeLabel.text = String(remainingTime)
            newTimeLabel.color = getTimeColor()
            
            if state == .decrease && newTimeLabel.position.y > goal {
                newTimeLabel.position.y = goalDown
            } else if state == .increase && newTimeLabel.position.y < goal {
                newTimeLabel.position.y = goalUp
            }
        }
        
        func runLabelActions(state: ChangingTimeState) {
            
            log("runs \(state) action")
            
            let duration: TimeInterval = 0.35
            
            configureNewLabel(state: state)
            
            if state == .decrease {
                
                
                let currentUpAction = SKAction.group([SKAction.moveTo(y: goalUp, duration: duration),
                                                      SKAction.fadeOut(withDuration: duration)])
                currentTimeLabel.removeAllActions()
                
                changingTimeState = .decrease
                currentTimeLabel.run(currentUpAction)
                
            } else if state == .increase {
                
                let currentDownAction = SKAction.group([SKAction.moveTo(y: goalDown, duration: duration),
                                                        SKAction.fadeOut(withDuration: duration)])
                currentTimeLabel.removeAllActions()
                
                changingTimeState = .increase
                currentTimeLabel.run(currentDownAction)
            }
            
            let newAction = SKAction.group([SKAction.moveTo(y: goal, duration: duration),
                                                SKAction.fadeIn(withDuration: duration)])
            let newWithWaitAction = SKAction.sequence([newAction, SKAction.wait(forDuration: 0.2)])
            newTimeLabel.removeAllActions()
            newTimeLabel.run(newWithWaitAction, completion: {
                
                let cache = self.currentTimeLabel
                self.currentTimeLabel = self.newTimeLabel
                self.newTimeLabel = cache
                
                checkQueue()
            })
        }
        
        func checkQueue() {
            
            log("action finished with state \(changingTimeState)")
            
            if changingTimeState == .waitForIncrease {
                log("\(changingTimeState) now increasing")
                runLabelActions(state: .increase)
            } else if changingTimeState == .waitForDecrease {
                log("\(changingTimeState) now decreasing")
                runLabelActions(state: .decrease)
            } else {
                changingTimeState = .no
                log("no waiting action, finished")
            }
        }
        
        if changingTimeState != .no {
            
            if state == .increase {
                changingTimeState = .waitForIncrease
            } else if state == .decrease {
                changingTimeState = .waitForDecrease
            }
            
            log("action already running, now \(changingTimeState)")
            
        } else {
            
            log("will choose action, currently no action running")
            
            switch state {
                
            case .increase:
                remainingTime += 1
                runLabelActions(state: .increase)
                
            case .decrease:
                remainingTime -= 1
                runLabelActions(state: .decrease)
                
            case .reset:
                if remainingTime < 5 {
                    remainingTime = 5
                    runLabelActions(state: .increase)
                }
            default:
                break
            }
        }
    }
 
    private func getTimeColor() -> UIColor {
        
        if remainingTime < 3{
            
            return red
            
        } else if remainingTime < 4 {
            
            return yellow
        
        } else {
            
            return green
            
        }
        
    }
    
    override func tappedfirstnode() {
        
        super.tappedfirstnode()
        
        if (firstNodeState == .untouched) {
            
            log("tapped first node -> increase time")
            changeTime(.increase)
            
        }
        
    }
    
    override func endForRevive() {
        
        timer.invalidate()
        super.endForRevive()
        
    }
    
    override func didRevive() {
        super.didRevive()
        
        changeTime(.reset)
    }
    
    private func timeStamp() -> String {
        
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "H:m:ss:SSSS"
        
        return df.string(from: d)
        
    }
    
    func log(_ s: String) {
        
        print("\(timeStamp()): \(s)")
        
    }
    
    override func fillNode(inNode node: SKSpriteNode) {
        super.fillNode(inNode: node)
        
        nodeCounter += 1
        
        if (nodeCounter % 5) == 0 {
        
            let textNode = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
            textNode.verticalAlignmentMode = .center
            textNode.horizontalAlignmentMode = .center
            textNode.fontSize = node.size.height * 1.1
            textNode.text = "+"
            textNode.fontColor = UIColor(named: "backgrounddark") ?? .black
            
            node.addChild(textNode)
            
        }
    }
    
    
    
    
}
