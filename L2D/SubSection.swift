//
//  SubSection.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 24/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit


enum fileType{
    case none
    case video
    case document
}

class SubSection: NSObject {
    var id : Int
    var name : String
    var fileKEY : String
    var rank : Int
    var type : fileType
    
    init(id:Int ,name:String, fileKEY : String, rank : Int, type : fileType ) {
        self.id = id
        self.name = name
        self.fileKEY = fileKEY
        self.rank = rank
        self.type = type
    }
    
    init(id:Int ,rank : Int) {
        self.name = ""
        self.id = id
        self.fileKEY = ""
        self.rank = rank
        self.type = .none
    }
    

}
