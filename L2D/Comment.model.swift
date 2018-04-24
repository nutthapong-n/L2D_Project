//
//  Comment.model.swift
//  L2D
//
//  Created by Magnus on 4/23/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Comment : NSObject {
    var name : String
    var message : String
    var dateTime : Date
    var idMember : Int
    
    init(name: String, message: String, dateTime: Date, idMember: Int){
        self.name = name
        self.message = message
        self.dateTime = dateTime
        self.idMember = idMember
    }
    
    class func getComment(courseId : Int, completion : @escaping (_ commentList:[Comment]?)-> Void){
        
        let url = "\(Network.IP_Address_Master)/dialogue?courseId=\(courseId)"
        
        var commentList = [Comment]()
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in switch response.result{
            case.success(let value):
                let json = JSON(value)
                
                for (index,obj) in json {
                    var jsonComment = obj
                    
                    let a_comment = Comment(name: "\(jsonComment["member"]["name"]) \(jsonComment["member"]["surname"])", message: jsonComment["msg"].stringValue, dateTime: Date(timeIntervalSince1970: jsonComment["editTime"].doubleValue), idMember: jsonComment["member"]["idmember"].intValue)
                    
                    commentList.append(a_comment)
                }
                
                completion(commentList)
                return
                
            case.failure(let error):
                print(error)
                completion(nil)
                return
            }
        }
    }
    
    class func sendComment(courseId : Int,memberId : Int,message : String, completion: @escaping (_ comment : Comment? )-> Void){
        
        let url = "\(Network.IP_Address_Master)/dialogue/add?memberId=\(memberId)&courseId=\(courseId)"
        let parameters: Parameters = [
            "msg" : message
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in switch response.result{
            case.success(let value):
                let json = JSON(value)
                let comment = Comment(name: "\(json["member"]["name"]) \(json["member"]["surname"])", message: json["msg"].stringValue, dateTime: Date(timeIntervalSince1970: json["editTime"].doubleValue), idMember: json["member"]["idmember"].intValue)
                
                completion(comment)
                return
                
            case.failure(let error):
                print(error)
                completion(nil)
                return
            }
        }
    }
}
