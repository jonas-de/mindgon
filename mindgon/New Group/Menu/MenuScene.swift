//
//  MenuScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class MenuScene: Scene {

    
    //MARK: - Attributes
    
    ///the cardstack as an array
    var cards : [MenuCard]!
    
    ///Indicates wheter the settingsMenu is open
    var settingsMenuIsOpen: Bool = false
    
    ///Saves the touch of the card on the top of the stack
    var topCardTouch: MenuTouch?
    
    ///Indicates wheter the UI should be initialized
    var shouldInitializeUI: Bool = true
    
    
    //MARK: - Nodes
    
    ///button to open the settings
    var settingsButton: SKSpriteNode!
    
    ///the settings menu
    var settingsMenu: Settingsmenu!
    
    ///the label presenting the current points
    var diamondsLabel: DiamondsLabel!
    
    ///the label presenting shortly added points
    var addDiamondsLabel: SKLabelNode!
    
    
    
    //MARK: - Textures
    
    let settingsTexture = SKTexture(imageNamed: "zahnrad")

    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)

        ///doesnt setup the UI if it was initialized before
        if shouldInitializeUI {
            
            initializeUI()
            
        }
        
        initializeDiamondsLabel()
        
    }
    
    
    //MARK: - Custom initializer
    
    /**
        Initializes all nodes in the menu scene
        - settingsButton
        - settingsFocus
        - calls `initializeCardStack
    */
    private func initializeUI() {
        
        //SettingsButton
        func initializeSettingsButton() {
            
            let buttonSize = getFactor(0.125, max: 60)
            
            settingsButton = SKSpriteNode(texture: settingsTexture,
                                          color: .clear,
                                          size: CGSize(width: buttonSize,
                                                       height: buttonSize))
            
            settingsButton.position = CGPoint(x: safeFrame.maxX - buttonSize * 0.5,
                                              y: safeFrame.maxY - buttonSize * 0.5)
            
            addChild(settingsButton)
            
        }

        
        initializeSettingsButton()
        initializeCardStack()
        
        print("initialized")
        
    }
    
    ///Diamondslabel
    func initializeDiamondsLabel() {
        let defs = UserDefaults.standard
        
        if diamondsLabel != nil {
            
            diamondsLabel.removeFromParent()
            
        }
        
        if addDiamondsLabel != nil {
            
            addDiamondsLabel.removeFromParent()
            
        }
        
        let addPoints = defs.integer(forKey: "addpoints")
        
        let points = defs.integer(forKey: "points") + addPoints
        
        defs.set(points, forKey: "points")
        defs.set(0, forKey: "addpoints")
        
        diamondsLabel = DiamondsLabel(inScene: self, value: points, sizeFactor: 0.125)
        diamondsLabel.position = CGPoint(x: safeFrame.minX + 0.5 * diamondsLabel.size.width,
                                         y: safeFrame.maxY - diamondsLabel.size.height * 0.5)
        
        if addPoints != 0 {
            
            addDiamondsLabel = (diamondsLabel.text.copy() as! SKLabelNode)
            addDiamondsLabel.text = "+\(addPoints)"
            let newPosition = convert(diamondsLabel.text.position, from: diamondsLabel)
            addDiamondsLabel.position = CGPoint(x: newPosition.x + getFactor(0.02, max: 1000) + diamondsLabel.frame.width * 0.5,
                                                y: newPosition.y)
            
            addChild(addDiamondsLabel)
            addDiamondsLabel.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                                    SKAction.fadeOut(withDuration: 2.5)]))
            
        }
        
        addChild(diamondsLabel)
        
    }
    
    private func initializeCardStack() {
        
        //Initialize and setup the individual cards
        func initializeCards() {
            
            cards = [MenuCard(gameType: .special, scene: self),
                     MenuCard(gameType: .monochrom, scene: self),
                     MenuCard(gameType: .time, scene: self),
                     MenuCard(gameType: .normal, scene: self)]
            
            var newZ: CGFloat = 1
            
            for card in cards {
                
                card.zPosition = newZ
                newZ += 1
                card.zRotation = GameType.normal.rotation
                
                addChild(card)

            }
            
            //Animate rotation of cards
            func rotateCard(atIndex index: Int) {
                
                if let card = cards[safe: index] {
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(100), execute: {
                        
                        card.run(self.animateCardRotation(card.gameType))
                        rotateCard(atIndex: index - 1)
                        
                    })
                    
                }
                
            }
            
            rotateCard(atIndex: cards.endIndex - 1)
            
        }
        
        //Change the stack so that the last saved topcard is topcard again
        let topmode = GameType(rawValue: UserDefaults.standard.integer(forKey: "menutopcard"))
        
        func setTopCard() {
            
            while(cards.last!.gameType != topmode) {
                
                //removes the lowest card from the stack
                let newTopCard = cards.removeFirst()
                
                //gives the new topcard the highest zPosition
                newTopCard.zPosition = cards.last!.zPosition
                
                //moves all other cards one level down
                for card in cards {
                    card.zPosition = card.zPosition - 1
                }
                
                //puts the new topcard back in the stack
                cards.append(newTopCard)
                
            }
            
        }
        
        initializeCards()
        
        setTopCard()
        
    }
    
    
    //MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //Settings
            func checkSettings() {
                
                if settingsMenuIsOpen {
                    
                    settingsMenu.touchBegan(touch)
                    
                    return
                    
                }
                
            }
            
            //CardStack
            func checkCardStack() {
                
                if let topCard = cards.last {
                    
                    if topCard.contains(location) && topCardTouch == nil && !topCard.touchBegan(touch) {
                        
                        topCardTouch = MenuTouch(touch, from: location)
                        
                    }
                    
                }
                
            }
            
            checkSettings()
            
            checkCardStack()
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //Settings
            func checkSettings() {
                
                //When settingsMenu is closed
                if !settingsMenuIsOpen && settingsButton.contains(location) {
                    
                    openSettingsMenu()
                    return
                    
                }
                
                //When settingsMenu is open
                if settingsMenuIsOpen {
                    
                    if settingsMenu.contains(location) {
                        
                        settingsMenu.touchReleased(touch)
                        
                    } else {
                        
                        closeSettingsMenu()
                        
                    }
                    
                }
                
            }
            
            //CardStack
            func checkCardStack() {
                
                if let topcard = cards.last {
                    
                    //Hands the touch object to the card
                    topcard.touchReleased(touch)
                    
                }
                
                if let topTouch = topCardTouch {
                    
                    if touch.isEqual(topTouch.touch) {
                        
                        swipeCards(direction: topTouch.getSwipeDirection(newlocation: location))
                        
                        topCardTouch = nil
                        
                    }
                    
                }
                
            }
            
            checkSettings()
            
            checkCardStack()
            
        }
        
    }
    //TODO: Cancelled touches
    
    
    //MARK: - Custom functions
    
    private func swipeCards(direction: SwipeDirection) {
        
        
        func swipeRight() {
            
            let oldTopCard = cards.removeLast()
            
            let zPositionAdjustment = SKAction.run {
                
                for card in self.cards {
                    
                    card.zPosition += 1
                    
                }
                
                oldTopCard.zPosition = self.cards.first!.zPosition - 1
                
            }
            
            let animateRightSwipe = SKAction.sequence([animateRightSwipeRight(oldTopCard),
                                                       zPositionAdjustment,
                                                       animateRightSwipeLeft(oldTopCard)])
            
            oldTopCard.run(animateRightSwipe, completion: {
                
                //Puts the old topCard back in the stack
                self.cards.insert(oldTopCard, at: 0)
                
            })
            
        }
        
        func swipeLeft() {
            
            let oldDownCard = cards.removeFirst()
            
            let zPositionAdjustment = SKAction.run {
                
                for card in self.cards {
                    
                    card.zPosition -= 1
                    
                }
                
                oldDownCard.zPosition = self.cards.last!.zPosition + 1
                
            }
            
            let animateLeftSwipe = SKAction.sequence([animateLeftSwipeLeft(oldDownCard),
                                                      zPositionAdjustment,
                                                      animateLeftSwipeRight(oldDownCard)])
            
            oldDownCard.run(animateLeftSwipe, completion: {
                
                self.cards.append(oldDownCard)
                
            })
            
        }
        
        if cards.count > 1 {
            
            if direction == .right {
                
                swipeRight()
                
            }
            
            if direction == .left {
                
                swipeLeft()
                
            }
            
            let topmode = cards.last!.gameType.rawValue
            UserDefaults.standard.set(topmode, forKey: "menutopcard")
            
        }
        
    }
    
    private func openSettingsMenu() {
        
        func add() {
            
            if settingsMenu == nil {
                
                settingsMenu = Settingsmenu(scene: self)
                
            }
            
            addChild(settingsMenu)
            
        }
        
        func animate() {
            
            settingsButton.run(animateSettingsButton())
            focus.run(animateSettingsFocus())
            settingsMenu.run(animateSettingsMenu(), completion: {
                
                self.settingsMenu.animateNodeAppearance()
                
            })
            
        }
        
        settingsMenuIsOpen = true
        
        add()
        animate()
        
    }
    
    ///Closes the settings menu
    private func closeSettingsMenu() {
        
        settingsMenuIsOpen = false
        
        settingsButton.run(animateSettingsButton().reversed())
        focus.run(animateCloseSettings())
        
        settingsMenu.animateNodeClosing()
        settingsMenu.run(animateCloseSettings(), completion: {
            
            self.settingsMenu.removeFromParent()
            
        })
    
    }
    
}





