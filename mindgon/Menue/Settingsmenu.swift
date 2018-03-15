//
//  Settingsmenu.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class Settingsmenu: SKShapeNode {

    //MARK: - Attributes
    
    /// Determines wheter the device should give haptic feedback
    var shouldvibrate = UserDefaults.standard.bool(forKey: "settingsvibration") {
        didSet {
            UserDefaults.standard.set(shouldvibrate, forKey: "settingsvibration")
            self.setvibrationtexture()
        }
    }
    
    ///Determines wheter the vibrationnode is currently touched
    var vibrationtouch = false
    /*
    ///Blocks touches while an action is running that could be disrupted by other touches
    var blocktouches = false
    */
    
    //MARK: - Textures
    
    lazy var vibrationontexture = SKTexture(imageNamed: "vibrationon")
    lazy var vibrationofftexture = SKTexture(imageNamed: "vibrationoff")
    
    
    //MARK: - Nodes
    
    ///the button that switches on/off the haptic feedback
    var vibration: SKSpriteNode!
    
    
    //MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(safeframe: CGRect){
        
        super.init()
        
        //Self.setup
        
        let factor: CGFloat = 0.75
        
        let rect = CGRect(x: 0, y: 0,
                          width: factor * safeframe.width,
                          height: (factor / 3.5) * safeframe.width)
        
        self.path = CGPath(roundedRect: rect,
                           cornerWidth: 0.07 * factor * safeframe.width,
                           cornerHeight: 0.07 * factor * safeframe.width,
                           transform: nil)
        
        self.alpha = 0
        self.lineWidth = 5
        self.strokeColor = .white
        self.fillColor = #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1)
        self.position = CGPoint(x: safeframe.midX - 0.5 * factor * safeframe.width, y: safeframe.midY)
        self.zPosition = 10
        
        setupvibration(size: rect)
        
    }
    
    
    //MARK: - Setup nodes
    
    func shownodes(){
        let appear = SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction(named: "appear")!])
        vibration.run(appear)
    }
    
    func closenodes(){
        vibration.alpha = 0
    }
    
    
    //MARK: - Setup vibration
    
    private func setupvibration(size: CGRect) {
        vibration = SKSpriteNode(texture: getvibrationtexture(), color: .clear,
                                 size: CGSize(width: 0.6 * size.height ,
                                              height: 0.6 * size.height))
        vibration.position = CGPoint(x: 0.5 * size.width,
                                     y: 0.5 * size.height)
        vibration.alpha = 0
        addChild(vibration)
    }
    
    private func getvibrationtexture() -> SKTexture {
        if(shouldvibrate){
            return vibrationontexture
        }
        return vibrationofftexture
        
    }
    
    private func setvibrationtexture() {
        let scalebigger = SKAction.scale(to: 1.0, duration: 0.08)
        self.vibration.texture = self.getvibrationtexture()
        self.vibration.run(scalebigger)
    }
    
    
    //MARK: - Handle touches
    
    func starttouch(_ l: CGPoint) {
        
        if(vibration.contains(l) &&
            !vibrationtouch) {
            
            vibrationtouch = true
            vibration.run(SKAction.scale(to: 0.8, duration: 0.08))
            
        }
        
    }
    
    
    func endtouch(_ l: CGPoint) {
        
        //Check vibration
        if (vibrationtouch && vibration.contains(l)){
            shouldvibrate = !shouldvibrate
            vibrationtouch = false
        } else if (vibrationtouch) {
            vibration.run(SKAction.scale(to: 1, duration: 0.08))
            vibrationtouch = false
        }
        
        
    }
    
    
}
