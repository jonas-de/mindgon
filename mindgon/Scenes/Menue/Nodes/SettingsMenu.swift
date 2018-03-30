//
//  SettingsMenu.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class Settingsmenu: SKShapeNode {
    
    //MARK: - Attributes
    
    /// Determines wheter the device should give haptic feedback
    var shouldVibrate: Bool = UserDefaults.standard.bool(forKey: "settingsvibration") {
        
        didSet {
            
            UserDefaults.standard.set(shouldVibrate, forKey: "settingsvibration")
            self.setvibrationtexture()
            
        }
        
    }
    
    ///Determines wheter the vibrationnode is currently touched
    var vibrationTouched = false
    
    //MARK: - Textures
    
    lazy var vibrationOnTexture = SKTexture(imageNamed: "vibrationon")
    lazy var vibrationOffTexture = SKTexture(imageNamed: "vibrationoff")
    
    
    //MARK: - Nodes
    
    ///the button that switches on/off the haptic feedback
    var vibration: SKSpriteNode!
    
    
    //MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    init(scene: Scene){
        
        super.init()
        
        let rect = CGRect(x: 0, y: 0,
                          width: scene.getfactor(0.75, max: 500),
                          height: scene.getfactor(0.75, max: 500) * 0.3)
        
        self.path = CGPath(roundedRect: rect,
                           cornerWidth: scene.getfactor(0.75, max: 500) * 0.07,
                           cornerHeight: scene.getfactor(0.75, max: 500) * 0.07,
                           transform: nil)
        
        position = CGPoint(x: scene.safeFrame.midX - 0.5 * scene.getfactor(0.75, max: 500),
                           y: scene.safeFrame.midY)
        zPosition = 10
        
        alpha = 0
        
        lineWidth = 5
        fillColor = #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1)
        strokeColor = .white
        
        initializeVibration(size: rect)
        
    }
    
    
    //MARK: - Setup nodes
    
    func animateNodeAppearance(){
        
        let appear = SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                        SKAction(named: "appear")!])
        vibration.run(appear)
        
    }
    
    func animateNodeClosing(){
        
        vibration.alpha = 0
        
    }
    
    
    //MARK: - Setup vibration
    
    private func initializeVibration(size: CGRect) {
        
        vibration = SKSpriteNode(texture: getVibrationTexture(), color: .clear,
                                 size: CGSize(width: 0.6 * size.height ,
                                              height: 0.6 * size.height))
        
        vibration.position = CGPoint(x: 0.5 * size.width,
                                     y: 0.5 * size.height)
        vibration.alpha = 0
        
        addChild(vibration)
        
    }
    
    private func getVibrationTexture() -> SKTexture {
        
        if shouldVibrate {
            
            return vibrationOnTexture
        }
        
        return vibrationOffTexture
        
    }
    
    private func setvibrationtexture() {
        
        self.vibration.texture = self.getVibrationTexture()
        
        self.vibration.run(SKAction.scale(to: 1.0, duration: 0.08))
        
    }
    
    
    //MARK: - Handle touches
    
    func touchBegan(_ touch: UITouch) {
        
        let location = touch.location(in: self)
        
        func checkVibration() {
            
            if vibration.contains(location) && !vibrationTouched  {
                
                vibrationTouched = true
                
                vibration.run(SKAction.scale(to: 0.8, duration: 0.08))
                
            }
            
        }
        
        checkVibration()
        
    }
    
    func touchReleased(_ touch: UITouch) {
        
        let location = touch.location(in: self)
        
        //Check vibration
        func checkVibration() {
            
            if vibrationTouched && vibration.contains(location) {
                
                shouldVibrate = !shouldVibrate
                vibrationTouched = false
                
            } else if vibrationTouched {
                
                vibrationTouched = false
                
                vibration.run(SKAction.scale(to: 1, duration: 0.08))
                
            }
            
        }
        
        checkVibration()
        
    }
    
    
}

