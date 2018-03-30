//
//  GameViewController.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    //MARK: - Overridden attributes
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    
    //MARK: - Scenes
    
    /// the scene that shows the menu
    lazy var menu = MenuScene(size: CGSize.zero)
    
    /// scene: `Gametyp.normal`
    lazy var normalgame = NormalScene(size: CGSize.zero)
    
    /// scene `Gametyp.time`
    lazy var timegame = TimeScene(size: CGSize.zero)
    
    /// scene `Gametyp.monochrom`
    lazy var monogame = MonoScene(size: CGSize.zero)
    
    /// scene `Gametyp.special`
    lazy var specialgame = SpecialScene(size: CGSize.zero)
    
    
    //MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firststartsetup()
    }
    
    override func viewWillLayoutSubviews() {
        if let view = self.view as! SKView? {
            
            //Setup the scene
            menu.size = view.bounds.size
            menu.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(menu)
            
            //Debug
            let shoulddebug: Bool = true
            view.showsFPS = shoulddebug
            view.showsNodeCount = shoulddebug
            //view.showsDrawCount = shoulddebug
            //view.showsQuadCount = shoulddebug
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(showmenu(_:)), name: .showmenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startgame(_:)), name: .startgame, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    //MARK: - Custom functions
    
    /**
    Setup when the app is started the first time
    - Settings (Vibration)
    */
    private func firststartsetup() {
        let defs = UserDefaults.standard
        if (!defs.bool(forKey: "firststartsetup")) {
            
            defs.set(true, forKey: "firststartsetup")
            defs.set(true, forKey: "settingsvibration")
            
        }
    }
    
    /**
    - Parameter gametype: GameTyp to find the correct scene
    - Returns:  The scene according to the parameter
    */
    private func getscene(forgametyp typ: GameType) -> SKScene {
        
        switch (typ) {
        case .normal:
            return normalgame
        case .time:
            return timegame
        case .monochrom:
            return monogame
        case .special:
            return specialgame
        }
        
    }
    
    
    //MARK: - Scenetransitions
    
    /**
     called when a scene notifies the Controller that the menu should appear
     - performs a transition to the menu
     - Parameter notification: The object created by the sender to transport information
     
     
    */
    @objc func showmenu(_ notification: Notification) {
        
        //checks if the view can be represent a SKView
        if let view = self.view as! SKView? {
            
            //checks if the menu-scene is already presented
            if view.scene != menu {
                
                //Setup the scene
                menu.size = view.bounds.size
                menu.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(with: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1), duration: 1)
                view.presentScene(menu, transition: transition)
                
            }
            
        }
        
    }
    
    @objc func startgame(_ notification: Notification) {
        
        var typ: GameType = .normal
        if let data = notification.userInfo {
            typ = GameType(rawValue: (data["gametype"] as? Int ?? 0) ) ?? .normal
        }
        
        if let view = self.view as! SKView? {
            let transition = SKTransition.fade(with: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1) , duration: 1)
            
            //Setup the scene
            let scene = getscene(forgametyp: typ)
            scene.size = view.bounds.size
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene, transition: transition)
        }
    }
}
