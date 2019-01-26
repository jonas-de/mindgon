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
        return .portrait
    }
    
    
    //MARK: - Scenes
    
    /// the scene that shows the menu
    lazy var menu = MenuScene(size: .zero)
    
    /// scene: `GameType.normal`
    lazy var normalGame = NormalScene(size: .zero)
    
    /// scene `GameType.time`
    lazy var timeGame = TimeScene(size: .zero)
    
    /// scene `GameType.monochrom`
    lazy var monochromeGame = MonoScene(size: .zero)
    
    /// scene `GameType.special`
    lazy var specialGame = SpecialScene(size: .zero)
    
    
    //MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFirstStart()
    }
    
    override func viewWillLayoutSubviews() {
        
        if let view = self.view as! SKView? {
            
            //Setup the scene
            menu.size = view.bounds.size
            menu.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(menu)
            
            //Debug
            let shouldDebug: Bool = false
            view.showsFPS = shouldDebug
            view.showsNodeCount = shouldDebug
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMenu(_:)), name: .showmenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startGame(_:)), name: .startgame, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    //MARK: - Custom functions
    
    /**
    Setup when the app is started the first time
     - Settings: Vibration on
    */
    private func initializeFirstStart() {
        
        let defs = UserDefaults.standard
        
        if !defs.bool(forKey: "firststartsetup") {
            
            defs.set(true, forKey: "firststartsetup")
            defs.set(true, forKey: "settingsvibration")
          
        }
        
    }
    
    /**
    - Parameter type: GameType to find the correct scene
    - Returns:  The scene according to the parameter
    */
    private func getScene(forGameType type: GameType) -> GameScene {
        
        switch type {
        case .normal:
            return normalGame
        case .time:
            return timeGame
        case .monochrom:
            return monochromeGame
        case .special:
            return specialGame
        }
        
    }
    
    /**
     Creates a new scene-object for the specific gameType after a game to reset all nodes
     - Parameter type: GameTyp to find the correct scene
     */
    private func resetScene(forGameType type: GameType)  {
        
        switch type {
        case .normal:
            normalGame = NormalScene(size: .zero)
        case .time:
            timeGame = TimeScene(size: .zero)
        case .monochrom:
            monochromeGame = MonoScene(size: .zero)
        case .special:
            specialGame = SpecialScene(size: .zero)
        }
        
    }
    
    
    //MARK: - Scene transitions
    
    /**
     called when a scene notifies the Controller that the menu should appear
     1. if a value for the key "gamesender" is available in the userInfo dictionary, special cleanup is done for the scene of the given gametype
     2. performs a transition to the menu
     
     - Parameter notification: The object created by the sender to transport information
    */
    @objc func showMenu(_ notification: Notification) {
        
        //checks if the view can be represent a SKView
        if let view = self.view as! SKView? {
            
            //checks if the menu-scene is already presented
            if view.scene != menu {
                
                //Setup the scene
                menu.size = view.bounds.size
                menu.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(with: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1), duration: 1)
                
                if let data = notification.userInfo as? [String : GameType] {

                    
                    let gameType = data["gamesender"] ?? .normal
                    
                    resetScene(forGameType: gameType)
                    
                    NotificationCenter.default.post(name: Notification.Name("update\(gameType.id)"), object: nil)
                    
                    menu.shouldInitializeUI = false
                    
                }
                
                view.presentScene(menu, transition: transition)
                
            }
            
        }
        
    }
    
    /**
     called when a scene notifies the Controller that a specified gamescene should appear
     1. searches for a value (key: "gametype") in the userInfo object of the notification to determine the correct gametype
     2. performs a transition to the scene of the specified gameType
     - Parameter notification: The object created by the sender to transport information
     */
    @objc func startGame(_ notification: Notification) {
        
        //Find the correct gametype
        var type: GameType = .normal
        
        if let data = notification.userInfo {
            
            type = GameType(rawValue: (data["gametype"] as? Int ?? 0) ) ?? .normal
            
        }
        
        if let view = self.view as! SKView? {
            
            //Setup the scene
            let scene = getScene(forGameType: type)
            
            scene.size = view.bounds.size
            scene.scaleMode = .aspectFill
            
            //Present the scene
            view.presentScene(scene, transition: SKTransition.fade(with: UIColor(named: "backgrounddark") ?? .black , duration: 1))
            
        }
        
    }
    
}
