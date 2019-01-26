//
//  Helper.swift
//  mindgon
//
//  Created by Jonas Andersson on 29.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

class Helper {
    
    /**
     function that names the system font depending on the weight
     - Parameter weight: the weight of the font as UIFont.Weight
     - Returns: the name of the font
    */
    static func getSystemFontName(weight: UIFont.Weight) -> String{
        
        return UIFont.systemFont(ofSize: 10, weight: weight).fontName
        
    }
    
}
