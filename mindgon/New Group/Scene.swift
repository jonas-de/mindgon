//
//  Scene.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class Scene: SKScene {
    
    
    //MARK: - Attributes
    
    ///a rectangle in which content can be drawn without any intersection with the displayrim (edges, notch at iPhone X)
    var safeFrame: CGRect!
    
    ///a shorter way to access the UserDefaults.standard
    let defs = UserDefaults.standard
    
    
    //MARK: - Nodes
    
    ///a node that focuses all nodes with a zPosition >= 10
    var focus: SKSpriteNode!
    
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(named: "backgrounddark") ?? .black
    
        safeFrame = getSafeFrame()
        
        //print(safeFrame)
        
        initializeFocus()
        
    }
    
    
    //MARK: - Initialize nodes
    
    /**
     - creates a rectangle in which content can be drawn without any intersection with the displayrim (edges, notch at iPhone X)
     - adds custom insets if the insets provided by the device are too small
     - `insetMin`: The minimum value for insets in all directions
     - returns: the rectangle acccording to the conditions above
    */
    private func getSafeFrame() -> CGRect{
        
        //Creates the minimum inset value according to the devices display-size
        let insetMin = getFactorForSceneSize(0.02, max: 25)
        
        let origin = self.convertPoint(toView: CGPoint(x: 0, y: 0))
        
        //Updates the insets if they don't confirm the minimum value
        var ins = self.view!.safeAreaInsets
        
        if ins.left < insetMin {
            
            ins.left = insetMin
            
        }
        
        if ins.right < insetMin {
            
            ins.right = insetMin
            
        }
        
        if ins.top < insetMin {
            
            ins.top = insetMin
            
        }
        
        if ins.bottom < insetMin {
            
            ins.bottom = insetMin
            
        }
        
        //Creates the values needed for the correct positioning of the safeFrame
        let safeFrameAnchor = CGPoint(x: self.convertPoint(fromView: CGPoint(x: ins.left,
                                                                            y: origin.y)).x,
                                     y: self.convertPoint(fromView: CGPoint(x: origin.x,
                                                                            y: ins.top)).y)
        
        let safeFrameAnchorInsets = CGPoint(x: self.convertPoint(fromView: CGPoint(x: view!.frame.width - ins.right,
                                                                                   y: origin.y)).x,
                                           y: self.convertPoint(fromView: CGPoint(x: origin.x,
                                                                                  y: view!.frame.height - ins.bottom)).y)
        
        return CGRect(x: safeFrameAnchor.x,
                      y: safeFrameAnchor.y,
                      width: safeFrameAnchorInsets.x - safeFrameAnchor.x,
                      height: safeFrameAnchorInsets.y - safeFrameAnchor.y)
        
    }
    
    
    func initializeFocus(){
        
        focus = SKSpriteNode(color: UIColor(named: "backgrounddark") ?? .black,
                             size: size)
        
        focus.position = CGPoint(x: 0.5 * size.width,
                                 y: 0.5 * size.height)
        
        focus.zPosition = 9
        focus.alpha = 0
        
        addChild(focus)
        
    }
    
    
    //MARK: - Layout
    
    /**
     function that computes the the length (width or height) of a node
     according to the size of the safeFrame
     - Parameter factor: the proportion of the smaller length of the safeFrame
     - Parameter max: The maximum length of the node
     - Returns: the computed length as CGFloat
    */
    func getFactor(_ factor: CGFloat, max: CGFloat) -> CGFloat {
        
        if safeFrame.width < safeFrame.height {
            
            let factored = safeFrame.width * factor
            return factored < max ? factored : max
            
        } else {
            
            let factored = safeFrame.height * factor
            return factored < max ? factored : max
            
        }
        
    }
    
    /**
     function that computed the length (width or height) of a node
     according to the size of the scene
     - Parameter factor: the proportion of the smaller length of the scene size
     - Parameter max: The maximum length of the node
     - Returns: the computed length as CGFloat
    */
    func getFactorForSceneSize(_ factor: CGFloat, max: CGFloat) -> CGFloat {
        
        let size = frame.size
        
        if size.width < size.height {
            
            let factored = size.width * factor
            return factored < max ? factored : max
            
        } else {
            
            let factored = size.height * factor
            return factored < max ? factored : max
            
        }
        
    }
    
    
    //MARK: - Debug
    
    ///creates and adds a node based on the safeFrame
    func showSafeFrame(){
        
        let safeNode = SKShapeNode(rect: self.safeFrame)
        safeNode.fillColor = .red
        safeNode.strokeColor = .white
        addChild(safeNode)
        
    }
}
