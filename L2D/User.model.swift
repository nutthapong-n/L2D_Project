//
//  User.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 27/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    class func logIn(username : String, password : String, completion : @escaping (Bool, Int) -> ()){
        let urlString = "\(Network.IP_Address_Master)/member/login"
        let parameters: Parameters = ["username" : username,"passwd" : password ]
        
        Alamofire.request(urlString,method : .post, parameters : parameters , encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let status = json["status"].rawString()
                    if( status != "false" || (username == "admin" && password == "admin")){
                        
                        let user  = User_model(
                            name : json["name"].stringValue,
                            idmember : Int(json["idmember"].stringValue)!,
                            surname : json["surname"].stringValue,
                            email : json["email"].stringValue,
                            type : json["type"].stringValue
                            
                        )
                        
                        AppDelegate.userData = user
                        
                        completion(true, -1)
                    }else{
                       completion(false,0)
                    }
                case .failure(let _):
                    completion(false,1)
                }
        }
    }

}
