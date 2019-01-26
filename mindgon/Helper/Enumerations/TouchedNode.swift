//
//  TouchedNode.swift
//  mindgon
//
//  Created by Jonas Andersson on 30.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit


/**
 Represents the currently touched node in a game
 - ## cases
    - no
    - firstNode
    - node(index: Int)
 */
enum TouchedNode {
    
    case no
    case firstNode(touch: UITouch)
    case aNode(touch: UITouch)
    case node(index: Int, touch: UITouch)
    
    func getIndex() -> Int {
        switch self {
            
        case .node(let index, _):
            
            return index
            
        default:
            
            return -1
            
        }
    }
    
}

//MARK: - Equatable

extension TouchedNode: Equatable {
    
    static func ==(lhs: TouchedNode, rhs: TouchedNode) -> Bool {
        
        switch (lhs, rhs) {
            
        case (let .firstNode(touch1), let .firstNode(touch2)):
            
            return touch1 == touch2
            
        case (let .node(index1, touch1), let .node(index2, touch2)):
            
            return index1 == index2 && touch1 == touch2
            
        case (.no, .no):
            
            return true
            
        case (let .node(_, touch1), let .aNode(touch2)):
            
            return touch1 == touch2
            
        default:
            
            return false
            
        }
        
    }
    
}

