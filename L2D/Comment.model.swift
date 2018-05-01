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
    var name : String = ""
    var message : String = ""
    var dateTime : Date = Date()
    var idMember : Int = 0
    var idComment : Int = 0
    var subComment = [Comment]()
    
    override init() {
        super.init()
    }
    
    init(name: String, message: String, dateTime: Date, idMember: Int, idComment: Int){
        self.name = name
        self.message = message
        self.dateTime = dateTime
        self.idMember = idMember
        self.idComment = idComment
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
                    
                    let a_comment = Comment(name: "\(jsonComment["member"]["name"]) \(jsonComment["member"]["surname"])", message: jsonComment["msg"].stringValue, dateTime: Date(timeIntervalSince1970: jsonComment["editTime"].doubleValue / 1000), idMember: jsonComment["member"]["idmember"].intValue, idComment: jsonComment["iddialogue"].intValue)
                    
                    if(jsonComment["sub-dialogues"] != JSON.null){
                        
                        for(inner_index,inner_obj) in jsonComment["sub-dialogues"] {
                            var jsonCommentInner = inner_obj
                            let inner_comment = Comment(name: "\(jsonCommentInner["member"]["name"]) \(jsonCommentInner["member"]["surname"])", message: jsonCommentInner["msg"].stringValue, dateTime: Date(timeIntervalSince1970: jsonCommentInner["editTime"].doubleValue / 1000), idMember: jsonCommentInner["member"]["idmember"].intValue, idComment: jsonCommentInner["iddialogue"].intValue)
                            
                            a_comment.subComment.append(inner_comment)
                        }
                    }
                    
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
    
    class func sendComment(courseId : Int,memberId : Int,message : String, parentId : Int?, completion: @escaping (_ comment : Comment? )-> Void){
        
        let url = ( parentId == nil ) ? "\(Network.IP_Address_Master)/dialogue/add?memberId=\(memberId)&courseId=\(courseId)" : "\(Network.IP_Address_Master)/dialogue/add?memberId=\(memberId)&courseId=\(courseId)&parentId=\(parentId ?? 0)"
        
        let parameters: Parameters = [
            "msg" : message
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in switch response.result{
            case.success(let value):
                let json = JSON(value)
                let comment = Comment(name: "\(json["member"]["name"]) \(json["member"]["surname"])", message: json["msg"].stringValue, dateTime: Date(timeIntervalSince1970: json["editTime"].doubleValue / 1000), idMember: json["member"]["idmember"].intValue, idComment: json["iddialogue"].intValue)
                
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
