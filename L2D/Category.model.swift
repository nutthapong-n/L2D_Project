//
//  Category.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/31/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Category : NSObject{
    
    var name: String = ""
    var courseIdList : [Int]?
    
    init(name:String, courseIdList:[Int]?){
        self.name = name
        self.courseIdList = courseIdList
    }
    
    class func getAllCat() -> [Category]{
        var cate = [Category]()
        cate.append(Category(name:"Programmer",courseIdList:[Int]()))
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
    
    class func getAllCategory(completion : @escaping ( [Category]) -> Void){
        var category = [Category]()
        
        Alamofire.request(Network.IP_Address_Master+"/category",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                for obj in json{
                    let this_category = obj.1
                    category.append(Category(name:"\(this_category["categoryName"])",courseIdList:this_category["courseList"].object as? [Int]))
                }
                completion(category)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
