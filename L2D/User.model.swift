//
//  User.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 27/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class User_model: NSObject {


    var name: String
    var idmember: Int
    var surname : String
    var email : String
    var type : String
    
    init(name:String ,idmember:Int ,surname:String ,email:String ,type:String){
        self.name = name
        self.idmember = idmember
        self.surname = surname
        self.email = email
        self.type = type
    }
    
    class func getAllCat() -> [Category]{
        var cate = [Category]()
        cate.append(Category(name:"Programmer", courseIdList: [Int]()))
        cate.append(Category(name:"Design",courseIdList:[Int]()))
        cate.append(Category(name:"Business",courseIdList:[Int]()))
        cate.append(Category(name:"Marketing",courseIdList:[Int]()))
        cate.append(Category(name:"Music",courseIdList:[Int]()))
        cate.append(Category(name:"IT & Software",courseIdList:[Int]()))
        cate.append(Category(name:"Development",courseIdList:[Int]()))
        cate.append(Category(name:"Helth",courseIdList:[Int]()))
        cate.append(Category(name:"Fitness",courseIdList:[Int]()))
        cate.append(Category(name:"Productivity",courseIdList:[Int]()))
        return cate
    }

}
