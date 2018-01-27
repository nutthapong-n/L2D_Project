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
        cate.append(Category(name:"Programmer"))
        cate.append(Category(name:"Design"))
        cate.append(Category(name:"Business"))
        cate.append(Category(name:"Marketing"))
        cate.append(Category(name:"Music"))
        cate.append(Category(name:"IT & Software"))
        cate.append(Category(name:"Development"))
        cate.append(Category(name:"Helth"))
        cate.append(Category(name:"Fitness"))
        cate.append(Category(name:"Productivity"))
        return cate
    }

}
