//
//  Comment.model.swift
//  L2D
//
//  Created by Magnus on 4/23/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class Comment : NSObject {
    var name : String
    var message : String
    var dateTime : Date
    
    init(name: String, message: String, dateTime: Date){
        self.name = name
        self.message = message
        self.dateTime = dateTime
    }
}
