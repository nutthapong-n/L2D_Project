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
    var section : [Section_model]?
    
    init(id:Int ,categoryId:Int ,detail:String ,createdDate:Float ,key:String ,name:String ,owner:String, img:String , section : [Section_model]) {
        self.id = id
        self.categoryId = categoryId
        self.detail = detail
        self.createdDate = createdDate
        self.key = key
        self.name = name
        self.owner = owner
        self.img = img
        self.section = section
    }
    
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
    
    func Register(completion : @escaping (Bool) -> ()){
        let user_id = AppDelegate.userData?.idmember
        let user_id_str = user_id != nil ? "\(user_id!)" : ""
        if(self.id == 0 || user_id_str == ""){
            print("L2D Warning : coursr id or user id is null")
            completion(false)
            return
        }
        let url = "\(Network.IP_Address_Master)/course/addRegis?courseId=\(self.id)&memberId=\(user_id_str)"
        print(url)
        Alamofire.request(url,method : .post , encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    print(value)
                    completion(true)
                    
                    
                //                        let array = json[0]["name"].rawString()
                case .failure(let error):
                    print(error)
                    completion(false)
                }
        }
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
        let urlString = "\(Network.IP_Address_Master)/course?id=\(id)"
        
        let course = Course(id:id, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard" , section : [
            Section_model(id: 1, name: "section1", subSection: [
                SubSection(id: 1, name: "section1_sub1"),
                SubSection(id: 2, name: "section1_sub2"),
                SubSection(id: 3, name: "section1_sub3")]),
            Section_model(id: 2, name: "section2", subSection: [
                SubSection(id: 1, name: "section2_sub1"),
                SubSection(id: 2, name: "section2_sub2"),
                SubSection(id: 3, name: "section2_sub3")]),
            Section_model(id: 3, name: "section3", subSection: [
                SubSection(id: 1, name: "section3_sub1"),
                SubSection(id: 2, name: "section3_sub2"),
                SubSection(id: 3, name: "section3_sub3")])
            ])
        
        completion(course)
//        Alamofire.request(urlString,method : .get , encoding: JSONEncoding.default)
//            .responseJSON{
//
//                response in switch response.result{
//                case .success(let value):
//                    let json = JSON(value)
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
//                    completion(course)
//                case .failure(let error):
//                    let course = Course(id:1, categoryId:1, detail:"detail", createdDate:12221.13, key:"key", name: "Basic Prograamming",owner: "mit",img:"keyboard" , section : [
//                        Section_model(id: 1, name: "section1", subSection: [
//                            SubSection(id: 1, name: "sub1"),
//                            SubSection(id: 2, name: "sub2"),
//                            SubSection(id: 3, name: "sub3")]),
//                        Section_model(id: 1, name: "section2", subSection: [
//                            SubSection(id: 1, name: "sub1"),
//                            SubSection(id: 2, name: "sub2"),
//                            SubSection(id: 3, name: "sub3")]),
//                        Section_model(id: 1, name: "section3", subSection: [
//                            SubSection(id: 1, name: "sub1"),
//                            SubSection(id: 2, name: "sub2"),
//                            SubSection(id: 3, name: "sub3")])
//                        ])
//                    completion(course)
//                    }
//                }
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
                    print(error)
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
    
    class func getCourseByCourseId(courseID : Int, completion : @escaping (Course) -> Void){
        
        Alamofire.request(Network.IP_Address_Master+"/course?idCourse=\(courseID)",method : .get, encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let this_course = JSON(value)
                    
                    print(this_course)
                    completion(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: Int(this_course["categoryId"].stringValue)!,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"].stringValue)!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: "",
                        img: "java"
                    ))
                case .failure(let error):
                    print(error)
                    
                }
        }
            
    }
    
    class func getCourseBySearchName(courseName:String, completion : @escaping ( [Course]) -> Void){
        var course = [Course]()
        
        Alamofire.request(Network.IP_Address_Master+"/course?name=\(courseName)",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                for obj in json{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: Int(this_course["categoryId"].stringValue)!,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"] != JSON.null ? this_course["createdDate"].stringValue : "0")!,
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
    
    class func getCourseBySearchInstructor(instructorName:String, completion : @escaping ([Course])-> Void){
        var course = [Course]()
        
        Alamofire.request(Network.IP_Address_Master+"/course?teacherName=\(instructorName)",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case.success(let value):
                let json = JSON(value)
                for obj in json{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: Int(this_course["categoryId"].stringValue)!,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"] != JSON.null ? this_course["createdDate"].stringValue : "0")!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: "",
                        img: "java"
                    ))
                }
                completion(course)
            case.failure(let error):
                print(error)
            }
        }
        
    }
        
    
}

