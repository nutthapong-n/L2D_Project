//
//  CourseWithImgPath.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 25/3/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseWithImgPath: NSObject {
    var id : Int
    var name:String
    var owner:String
    var imgPath: String
    var categoryId : Int
    var detail : String
    var createdDate : Float
    var key : String
    var section : [Section_model]?
    var rating : Double
    var rateCount : Int
    
    init(id:Int ,categoryId:Int ,detail:String ,createdDate:Float ,key:String ,name:String ,owner:String, path:String, rating:Double, rateCount: Int) {
        self.id = id
        self.categoryId = categoryId
        self.detail = detail
        self.createdDate = createdDate
        self.key = key
        self.name = name
        self.owner = owner
        self.imgPath = path
        self.rating = rating
        self.rateCount = rateCount
    }

}
