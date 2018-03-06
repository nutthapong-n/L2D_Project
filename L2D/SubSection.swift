//
//  SubSection.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 24/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class SubSection: NSObject {
    var id : Int
    var name : String
    var videoKEY : String
    var rank : Int
    
    init(id:Int ,name:String, videoKEY : String, rank : Int) {
        self.id = id
        self.name = name
        self.videoKEY = videoKEY
        self.rank = rank
    }
    
    init(id:Int ,rank : Int) {
        self.name = ""
        self.id = id
        self.rank = rank
        self.videoKEY = ""
    }
    

}
