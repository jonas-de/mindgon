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
    
    var safeFrame: CGRect!
    
    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(named: "backgrounddark") ?? .black
    
        safeFrame = getsafeframe()
        
    }
    
    
    //MARK: - Custom functions
    
    /**
     - creates a rectangle in wich content can be drawn without any intersection with the displayrim (edges, notch at iPhone X)
     - adds custom insets if the insets provided by the device are too small
     - `insetminimum`: The minimum value for insets in all directions
     - returns: the rectangle acccording to the conditions above
    */
    private func getsafeframe() -> CGRect{
        
        //Creates the minimum inset value according to the devices display-size
        let insetminimum = getfactorforsize(0.02, max: 25)
        
        let origin = self.convertPoint(toView: CGPoint(x: 0, y: 0))
        
        //Updates the insets if they don't confirm the minimum value
        var ins = self.view!.safeAreaInsets
        
        if ins.left < insetminimum {
            
            ins.left = insetminimum
            
        }
        
        if ins.right < insetminimum {
            
            ins.right = insetminimum
            
        }
        
        if ins.top < insetminimum {
            
            ins.top = insetminimum
            
        }
        
        if ins.bottom < insetminimum {
            
            ins.bottom = insetminimum
            
        }
        
        //Creates the values needed for the correct positioning of the safeFrame
        let saferectanchor = CGPoint(x: self.convertPoint(fromView: CGPoint(x: ins.left,
                                                                            y: origin.y)).x,
                                     y: self.convertPoint(fromView: CGPoint(x: origin.x,
                                                                            y: ins.top)).y)
        
        let saferectanchorinsets = CGPoint(x: self.convertPoint(fromView: CGPoint(x: view!.frame.width - ins.right,
                                                                                  y: origin.y)).x,
                                           y: self.convertPoint(fromView: CGPoint(x: origin.x,
                                                                                  y: view!.frame.height - ins.bottom)).y)
        
        return CGRect(x: saferectanchor.x,
                      y: saferectanchor.y,
                      width: saferectanchorinsets.x - saferectanchor.x,
                      height: saferectanchorinsets.y - saferectanchor.y)
        
    }
    
    
    //MARK: - Layout
    
    /**
     function that computes the the length (width or height) of a node
     according to the size of the safeFrame
     - Parameter factor: the proportion of the smaller length of the safeFrame
     - Parameter max: The maximum length of the node
     - Returns: the computed length as CGFloat
    */
    func getfactor(_ factor: CGFloat, max: CGFloat) -> CGFloat {
        
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
    func getfactorforsize(_ factor: CGFloat, max: CGFloat) -> CGFloat {
        
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
    func showsafeframe(){
        let safenode = SKShapeNode(rect: self.safeFrame)
        safenode.fillColor = .red
        safenode.strokeColor = .white
        addChild(safenode)
    }
}
