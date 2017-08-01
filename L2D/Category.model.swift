//
//  Category.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/31/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import Foundation

class Category : NSObject{
    
    var name: String = ""
    
    init(name:String){
        self.name = name
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
