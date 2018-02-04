//
//  Section.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 24/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class Section_model: NSObject {
    
    var id : Int
    var name : String
    var subSection : [SubSection]?
    
    init(id : Int ,name:String ,subSection : [SubSection]?) {
        self.id = id
        self.name = name
        if(subSection != nil){
            self.subSection = subSection
        }
        
    }
    

}
