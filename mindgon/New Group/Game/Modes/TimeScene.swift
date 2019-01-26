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
    
    var changingTime = false
    var shouldIncreaseTime = false;
    
    let red = UIColor(named: "countdownred") ?? .red
    let yellow = UIColor(named: "countdownyellow") ?? .yellow
    let green = UIColor(named: "countdowngreen") ?? .green
    
    
    
    //MARK: - Nodes
    
    var currentTimeLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    var newTimeLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        gameType = .time
        
        
        
        super.didMove(to: view)
        
        initializeBackground()
        initializeCurrentTimeLabel()
        initializeNewTimeLabel()
        addChild(newTimeLabel)
        
        self.run(SKAction.wait(forDuration: 0.25)) {
            self.initializeTimer()
        }
        
        
    }
    
    //MARK: - Timer
    private func initializeBackground() {
        
    }
    
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
        //print("Font size \(getFactor(0.16, max: 120))")
        newTimeLabel.text = String(remainingTime)
        
        newTimeLabel.zPosition = 10
        newTimeLabel.position = CGPoint(x: safeFrame.maxX,
                                        y: safeFrame.maxY - getFactor(0.17, max: 125))
        
        newTimeLabel.alpha = 0
        
        
    }
    
    
    private func initializeTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    @objc private func timerFired() {
        
        print("timer fired")
        
        changeTime(decrease: true)
        
        if remainingTime < 0 {
            
            print("time is over")
            
            timer.invalidate()
            endGame()
            
        }
            
        
        
    }
    
    private func changeTime(decrease: Bool) {
        
        if decrease {
            
            remainingTime -= 1
            
            
            let moveOutAction = SKAction.moveBy(x: 0, y: getFactor(0.16, max: 150), duration: 0.5)
            
            let outAction = SKAction.group([SKAction.fadeOut(withDuration: 0.5),
                                            moveOutAction])
            
            
            
            changingTime = true
            currentTimeLabel.run(outAction)
            
            
            
            let moveInAction = SKAction.moveTo(y: safeFrame.maxY - getFactor(0.01, max: 125), duration: 0.5)
            
            let inAction = SKAction.group([SKAction.fadeIn(withDuration: 0.5),
                                            moveInAction])
            
            newTimeLabel.color = getTimeColor()
            newTimeLabel.text = String(remainingTime)
            
            newTimeLabel.run(inAction, completion: {
                
                self.changingTime = false
                
                let cache = self.currentTimeLabel
                
                self.currentTimeLabel = self.newTimeLabel
                
                self.newTimeLabel = cache
                self.initializeNewTimeLabel()
                
                if self.shouldIncreaseTime {
                    
                    self.changeTime(decrease: false)
                    
                }
                
            })
            
        } else {
            
            if changingTime {
                
                shouldIncreaseTime = true
                
            } else {
                
                shouldIncreaseTime = false
                
                timer.invalidate()
                
                remainingTime += 1
                
                let moveOutAction = SKAction.moveTo(y: safeFrame.maxY - getFactor(0.17, max: 150), duration: 0.5)
                moveOutAction.timingMode = .easeOut
                
                let outAction = SKAction.group([SKAction.fadeOut(withDuration: 0.5),
                                                moveOutAction])
                changingTime = true
                currentTimeLabel.run(outAction)
                
                
                
                newTimeLabel.position.y = safeFrame.maxY + getFactor(0.16, max: 150)
                
                let moveInAction = SKAction.moveTo(y: safeFrame.maxY - getFactor(0.01, max: 125), duration: 0.5)
                moveInAction.timingMode = .easeIn
                
                let inAction = SKAction.group([SKAction.fadeIn(withDuration: 0.5),
                                               moveInAction])
                
                newTimeLabel.color = getTimeColor()
                newTimeLabel.text = String(remainingTime)
                
                newTimeLabel.run(inAction, completion: {
                    
                    self.changingTime = false
                    
                    let cache = self.currentTimeLabel
                    
                    self.currentTimeLabel = self.newTimeLabel
                    
                    self.newTimeLabel = cache
                    self.initializeNewTimeLabel()
                    
                    self.initializeTimer()
                    
                })
                
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
            
            changeTime(decrease: false)
            
        }
        
    }
    
    override func touchedWrongNode(atIndex i: Int) {
        
        timer.invalidate()
        super.touchedWrongNode(atIndex: i)
        
    }
    
    
    
    
}
