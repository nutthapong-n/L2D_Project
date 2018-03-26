//
//  CourseForShow.Model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 31/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseForShow_Model: NSObject {

    var name : String
    var id : Int
    var type : Int
    var fileKey : String
    var filetype : fileType
    
    init(name:String ,id:Int , type:Int , fileKey : String, fileType : fileType){
        self.name = name
        self.id = id
        self.type = type
        self.fileKey = fileKey
        self.filetype = fileType
    }
}
