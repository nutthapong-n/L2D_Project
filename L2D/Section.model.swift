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
    var rank : Int
    var subSection : [SubSection]?
    
    init(id : Int ,name:String , rank : Int,subSection : [SubSection]?) {
        self.id = id
        self.name = name
        self.rank = rank
        if(subSection != nil){
            self.subSection = subSection
        }
        
    }
    
    func checkDuplicateSubsection(rank : Int) -> (result : Bool ,index : Int){
        for sub in subSection!{
            if(sub.rank == rank){
                return (true , (subSection?.index(of: sub))!)
            }
        }
        return (false , -1)
    }
    

}
