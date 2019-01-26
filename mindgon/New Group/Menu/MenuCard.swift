//
//  MenuCard.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit





/// A spritenode to choose the gamemode
class MenuCard: SKSpriteNode {

    
    //MARK: - Attributes
    
    ///The gamemodus that makes the difference between the cards
    var gameType: GameType
    
    ///saves the touch of the playbutton of the topcard
    var playButtonTouch: UITouch?
    
    var bestScore = 0 {
        didSet {
            
            bestLabel.text = String(bestScore)
            
        }
    }
    var lastScore = 0 {
        didSet {
            
            lastLabel.text = String(lastScore)
            
        }
    }
    
    
    //MARK: - Nodes
    
    let titleLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .bold))
    let bestLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .medium))
    let lastLabel = SKLabelNode(fontNamed: Helper.getSystemFontName(weight: .medium))
    var rim: SKShapeNode!
    var image: SKSpriteNode!
    var playButton: SKSpriteNode!
    
    
    //MARK: - Textures
    
    lazy var cardTexture = SKTexture(imageNamed: "kartemenu")
    lazy var newHighCardTexture = SKTexture(imageNamed: "kartenewhigh")
    
    
    //MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    init(gameType: GameType, scene: Scene) {

        self.gameType = gameType
        
        super.init(texture: nil, color: .clear, size: CGSize(width: scene.getFactor(0.85, max: 600),
                                                             height: scene.getFactor(0.85, max: 600) * 1.5))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScores),
                                               name: Notification.Name("update\(gameType.id)"), object: nil)
        
        position = CGPoint(x: scene.safeFrame.midX,
                           y: scene.safeFrame.midY)
        
        initializeRim()
        initializePlayButton()
        initializeSymbolImage()
        initializeLabels()
        
        updateScores()
        
    }
    
    
    //MARK: - Setup
    
    private func initializeLabels() {
        
        //TitleLabel
        func initializeTitleLabel() {
            
            titleLabel.horizontalAlignmentMode = .left
            titleLabel.fontSize = 0.11 * size.width
            titleLabel.fontColor = .white
            
            titleLabel.text = gameType.name
            
            titleLabel.position = CGPoint(x: -size.width/2 + size.width * 0.085,
                                          y: size.height / 2 - size.height * 0.115)
            
            addChild(titleLabel)
            
        }
        
        func resizeTitleLabel() {
            
            while titleLabel.frame.width > 0.8 * size.width {
                titleLabel.fontSize -= 0.1
            }
            
        }
        
        //BestLabel
        func initializeBestLabel() {
            
            bestLabel.horizontalAlignmentMode = .left
            bestLabel.fontSize = 0.1 * size.width
            bestLabel.fontColor = .white
            
            bestLabel.position = CGPoint(x: -self.size.width/2 + self.size.width * 0.2125,
                                         y: (self.size.height/2) - self.size.height * 0.211)
            
            addChild(bestLabel)
            
        }
        
        //LastLabel
        func initializeLastLabel() {
            
            lastLabel.horizontalAlignmentMode = .left
            lastLabel.fontSize = 0.1 * self.size.width
            lastLabel.fontColor = .white
            
            lastLabel.position = CGPoint(x: -self.size.width/2 + self.size.width * 0.5225,
                                         y: (self.size.height/2) - self.size.height * 0.21)
            
            addChild(lastLabel)
            
        }
        
        initializeTitleLabel()
        resizeTitleLabel()
        
        initializeBestLabel()
        initializeLastLabel()
        
    }
    
    ///setups the node to show the rim
    private func initializeRim() {
        
        rim = SKShapeNode(rect: CGRect(x: -size.width / 2,
                                       y: -size.height / 2,
                                       width: size.width, height: size.height),
                          cornerRadius: 0.1 * size.width)
        
        rim.strokeColor = .white
        rim.lineWidth = 7.5
        
        addChild(rim)
    }
    
    ///setups a node to show a button to start the game
    private func initializePlayButton() {
        
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "playbtn"),
                                  color: .clear,
                                  size: CGSize(width: size.width * 0.6,
                                               height: size.width * 0.6 * 0.4))
        
        playButton.position = CGPoint(x: 0, y: -(self.size.height / 3))
        
        addChild(playButton)
        
    }
    
    ///setups a node to show an image that represents the gamemode
    private func initializeSymbolImage(){
        
        let factor: CGFloat = 0.6
        
        image = SKSpriteNode(texture: gameType.image,
                             color: .clear,
                             size: CGSize(width: size.width * factor,
                                          height: size.width * factor))
        
        image.position = CGPoint(x: 0, y: size.width * factor * 0.025)
        
        addChild(image)
        
    }
    
    //MARK: - Handle scores
    
    ///updates the scores and sets the according texture
    @objc func updateScores() {
        
        let defs = UserDefaults.standard
        
        bestScore = defs.integer(forKey: "\(gameType.id)highscore")
        lastScore = defs.integer(forKey: "\(gameType.id)lastscore")
        
        setCardTexture()
        
    }
    
    ///return the texture of the card depending on the cardtyp
    private func setCardTexture(){
        
        if UserDefaults.standard.bool(forKey: "\(gameType.id)newhighscore") {
            
            texture = newHighCardTexture
        
        } else {
            
            texture =  cardTexture
            
        }
    
    }
    
    //MARK: - Handle touches
    
    /**
     called from the `touchesBegan(_:)` function in the according scene
     - Parameter touch: a touch from the set in the `touchesBegan(_:) function
     - Returns: a Bool indicating wether a working UI-element of the card is touched
    */
    func touchBegan(_ touch: UITouch) -> Bool {
        
        let location = touch.location(in: self)
        
        if playButton.contains(location) {
            
            playButton.run(SKAction.scale(to: 1.1, duration: 0.1))
            playButtonTouch = touch
            
            return true
            
        }
        
        return false
        
    }
    
    func touchReleased(_ touch: UITouch) {
        
        let location = touch.location(in: self)
        
        if touch.isEqual(playButtonTouch) {
            
            playButton.run(SKAction.scale(to: 1, duration: 0.1))
            
            playButtonTouch = nil
            
            if playButton.contains(location) {
                
                let data: [String: Int] = ["gametype": gameType.rawValue]
                NotificationCenter.default.post(name: .startgame, object: self, userInfo: data)
                
            }
            
        }
        
    }
    
    
}
