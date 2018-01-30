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
    
    class func getCoureById( id:Int , completion : @escaping ( Course) -> ()){
        let urlString = "http://158.108.207.7:8090/elearning/course?id=28"
        Alamofire.request(urlString,method : .get , encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
//                    let course = Course(
//                            id : Int(json["id"].stringValue)!,
//                            categoryId: json["categoryId"].stringValue == "" ? -1 : Int(json["categoryId"].stringValue)!,
//                            detail: json["detail"].stringValue,
//                            createdDate: json["createdDate"].stringValue == "" ? -1 : Float(json["createdDate"].stringValue)!,
//                            key: json["key"].stringValue,
//                            name : json["name"].stringValue,
//                            owner: "",
//                            img: "keyboard"
//                        )
                    let course = Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard")
                    completion(course)
                case .failure(let error):
                    let course = Course(
                        id : 0,
                        categoryId: 0,
                        detail: "",
                        createdDate: 0,
                        key: "",
                        name : "error",
                        owner: "",
                        img: "java"
                    )
                    completion(course)
                    }
                }
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
//                            var catId = this_course["categoryId"].stringValue == "" ? -1 : Int(this_course["categoryId"].stringValue)
                            course.append(Course(
                                id : Int(this_course["id"].stringValue)!,
                                categoryId: this_course["categoryId"].stringValue == "" ? -1 : Int(this_course["categoryId"].stringValue)!,
                                detail: this_course["detail"].stringValue,
                                createdDate: this_course["createdDate"].stringValue == "" ? -1 : Float(this_course["createdDate"].stringValue)!,
                                key: this_course["key"].stringValue,
                                name : this_course["name"].stringValue,
                                owner: "",
                                img: "keyboard"
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
}

