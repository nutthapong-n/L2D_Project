//
//  Course.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/27/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import Foundation

class Course : NSObject{
    var name:String = ""
    var owner:String = ""
    var img:String = ""
    
    init(name:String ,owner:String, img:String) {
        self.name = name
        self.owner = owner
        self.img = img
    }
    
    class func generateModelArray() -> [Course]{
        var course = [Course]()
        course.append(Course(name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(name: "java basic",owner: "nut", img:"java"))
        course.append(Course(name: "C# basic",owner: "mit",img:"download"))
        course.append(Course(name: "C Language",owner: "first", img:"c"))
        course.append(Course(name: "Xcode",owner: "hi", img:"xcode"))
        
        return course
    }
}
