//
//  Course.model.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/27/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Course : NSObject{
    var id : Int
    var name:String
    var owner:String
    var img:String
    var categoryId : Int
    var detail : String
    var createdDate : Float
    var key : String
    
    init(id:Int ,categoryId:Int ,detail:String ,createdDate:Float ,key:String ,name:String ,owner:String, img:String) {
        self.id = id
        self.categoryId = categoryId
        self.detail = detail
        self.createdDate = createdDate
        self.key = key
        self.name = name
        self.owner = owner
        self.img = img
    }
    
    class func generateModelArray() -> [Course]{
        var course = [Course]()
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))
        course.append(Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard"))

        return course
    }
    
    class func getAllCourse(completion : @escaping ( [Course]) -> Void){
        Alamofire.request("http://158.108.207.7:8090/elearning/course",method : .get , encoding: JSONEncoding.default)
        .responseJSON{
    
                response in switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        var course = [Course]()
    
                        for obj in json{
                            let this_course = obj.1
                            course.append(Course(
                                id : Int(this_course["id"].stringValue)!,
                                categoryId: Int(this_course["categoryId"].stringValue)!,
                                detail: this_course["detail"].stringValue,
                                createdDate: Float(this_course["createdDate"].stringValue)!,
                                key: this_course["key"].stringValue,
                                name : this_course["name"].stringValue,
                                owner: "",
                                img: "java"
                            ))
                        }
                    
                    completion(course)
                    
                    
//                        let array = json[0]["name"].rawString()
                case .failure(let error):
                    var course = [Course]()
                    course.append(Course(
                        id : 0,
                        categoryId: 0,
                        detail: "",
                        createdDate: 0,
                        key: "",
                        name : "error",
                        owner: "",
                        img: "java"
                    ))
                    completion(course)
                    
//                        self.alert(text : "ERROR CODE : 500 (sever error) : \(error)")
                }
            }
    }
    
    class func getMyCourse(completion : @escaping ( [Course]) -> Void){
        var course = [Course]()
        
        Alamofire.request(Network.IP_Address_Master+"/course?studentId=\(AppDelegate.userData?.idmember ?? 0)",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                for obj in json{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: Int(this_course["categoryId"].stringValue)!,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"].stringValue)!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: "",
                        img: "java"
                    ))
                }
                completion(course)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
