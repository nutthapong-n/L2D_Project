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
        let url = "\(Network.IP_Address_Master)/course/addRegis"
        let parameters: Parameters = ["courseId" : self.id,"memberId" : user_id_str ]
        Alamofire.request(url,method : .post ,parameters : parameters, encoding: JSONEncoding.default)
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
    
    class func getTopCourse(amount : Int, completion : @escaping (_ course:[Course]?, _ errorMessage:String?) -> ()){
        let url = "\(Network.IP_Address_Master)/course?top=\(amount)"
        Alamofire.request(url,method: .get,encoding: JSONEncoding.default).responseJSON{
            response in
            var courses : [Course] = []
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                
                let result = json["response"]
                if(result["status"] == false){
                    print(result["message"])
                    completion(nil,result["message"].stringValue)
                    return
                }
                
                let objCourses = json["courses"]
                for obj in objCourses{
                    let this_course = obj.1
                    courses.append(Course(
                        id : this_course["id"].intValue,
                        categoryId: this_course["categoryId"].intValue,
                        detail: this_course["detail"].stringValue,
                        createdDate: this_course["createdDate"].floatValue,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                        img: "download"
                    ))
                }
                
                completion(courses,nil)
            case .failure(let error):
                completion(nil,error.localizedDescription)
                print(error)
            }
            
        }
    }
    
    class func getCoureById( id:Int , completion : @escaping (_ course: Course?, _ errorMessage:String?) -> ()){
        let urlString = "\(Network.IP_Address_Master)/course?courseId=\(id)"
        Alamofire.request(urlString,method : .get , encoding: JSONEncoding.default)
            .responseJSON{

                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    let result = json["response"]
                    if(result["status"] == false){
                        print(result["message"])
                        completion(nil,result["message"].stringValue)
                        return
                    }
                    
                    let courseJSON = json["course"]
                    
                    let course = Course(
                            id : Int(courseJSON["id"].stringValue)!,
                            categoryId: courseJSON["categoryId"].stringValue == "" ? -1 : Int(courseJSON["categoryId"].stringValue)!,
                            detail: courseJSON["detail"].stringValue,
                            createdDate: courseJSON["createdDate"].stringValue == "" ? -1 : Float(courseJSON["createdDate"].stringValue)!,
                            key: courseJSON["key"].stringValue,
                            name : courseJSON["name"].stringValue,
                            owner: courseJSON["teacher"] != JSON.null ? "\(courseJSON["teacher"]["member"]["name"]) \(courseJSON["teacher"]["member"]["surname"])" : "",
                            img: "keyboard",
                            section : []
                        )
                    
                    let sections = courseJSON["sectionList"].arrayValue
                    
                    for section in sections!{
                        let thisSection = Section_model(
                            id: section["id"].intValue,
                            name: section["content"].stringValue,
                            subSection: [])
                        
                        let subSections = section["sub-section"].arrayValue
                        for sub in subSections{
                            let thisSub = SubSection(
                                id: sub["id"].intValue,
                                name: sub["content"].stringValue)
                            
                            thisSection.subSection?.append(thisSub)
                        }
                        course.section?.append(thisSection)
                    }
                    
                    completion(course,nil)
                case .failure(let error):
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
                    print(error)
//                    completion(course)
                    completion(nil,error.localizedDescription)
                    }
                }
        }
    
    
    
    
    class func getAllCourse(completion : @escaping ( _ courseList:[Course]? , _ errorMessage:String?) -> Void){
        Alamofire.request(Network.IP_Address_Master+"/course",method : .get , encoding: JSONEncoding.default)
        .responseJSON{
    
                response in switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        var course = [Course]()
                        
                        let result = json["response"]
                        if(result["status"] == false){
                            print(result["message"])
                            completion(nil,result["message"].stringValue)
                            return
                        }
                        
                        let courses = json["courses"]
    
                        for obj in courses{
                            
                            let this_course = obj.1
//                            var catId = this_course["categoryId"].stringValue == "" ? -1 : Int(this_course["categoryId"].stringValue)
                            course.append(Course(
                                id : Int(this_course["id"].stringValue)!,
                                categoryId: this_course["categoryId"].stringValue == "" ? -1 : Int(this_course["categoryId"].stringValue)!,
                                detail: this_course["detail"].stringValue,
                                createdDate: this_course["createdDate"].stringValue == "" ? -1 : Float(this_course["createdDate"].stringValue)!,
                                key: this_course["key"].stringValue,
                                name : this_course["name"].stringValue,
                                owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                                img: "keyboard"
                            ))
                        }
                    
                    completion(course,nil)
                    
                    
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
//                    completion(course)
                    completion(nil,error.localizedDescription)
                    
//                        self.alert(text : "ERROR CODE : 500 (sever error) : \(error)")
                }
            }
    }
    
    class func getMyCourse(completion : @escaping ( _ courseList : [Course]? , _ errorMessage:String?) -> Void){
        var course = [Course]()
        
        Alamofire.request(Network.IP_Address_Master+"/course?studentId=\(AppDelegate.userData?.idmember ?? 0)",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                let result = json["response"]
                if(result["status"] == false){
                    print(result["message"])
                    completion(nil,result["message"].stringValue)
                    return
                }
                
                let courses = json["courses"]
                for obj in courses{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: this_course["categoryId"] == JSON.null ? -1 : this_course["categoryId"].intValue,
                        detail: this_course["detail"].stringValue,
                        createdDate: this_course["createdDate"] == JSON.null ? 0.0 : this_course["createdDate"].floatValue ,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                        img: "java"
                    ))
                }
                completion(course,nil)
            case .failure(let error):
                completion(nil,error.localizedDescription)
                print(error)
            }
            
        }
        
    }
    
    class func getCourseByCourseId(courseID : Int, completion : @escaping (_ Course:Course? , _ errorMessage:String?) -> Void){
        
        Alamofire.request(Network.IP_Address_Master+"/course?courseId=\(courseID)",method : .get, encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    let result = json["response"]
                    if(result["status"] == false){
                        print(result["message"])
                        completion(nil,result["message"].stringValue)
                        return
                    }
                    
                    let this_course = json["course"]
                    
                    print(this_course)
                    completion(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: Int(this_course["categoryId"].stringValue)!,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"].stringValue)!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                        img: "java"
                    ),nil)
                case .failure(let error):
                    completion(nil,error.localizedDescription)
                    print(error)
                    
                }
        }
            
    }
    
    class func getCourseByCourseIdList(courseID : [Int], completion : @escaping (_ courseList:[Course]?,_ errorMessage:String?) -> Void){
        var course = [Course]()
        let coursesParameters = courseID.map{String($0)}.joined(separator: ",")
        Alamofire.request(Network.IP_Address_Master+"/course?courseId=\(coursesParameters)",method : .get, encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    let result = json["response"]
                    if(result["status"] == false){
                        print(result["message"])
                        completion(nil,result["message"].stringValue)
                        return
                    }
                    
                    let courses = json["courses"]
                    
                    for obj in courses{
                        let this_course = obj.1
                        course.append(Course(
                            id : Int(this_course["id"].stringValue)!,
                            categoryId: this_course["categoryId"] == JSON.null ? -1 : this_course["categoryId"].intValue ,
                            detail: this_course["detail"].stringValue,
                            createdDate: Float(this_course["createdDate"] != JSON.null ? this_course["createdDate"].stringValue : "0")!,
                            key: this_course["key"].stringValue,
                            name : this_course["name"].stringValue,
                            owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                            img: "java"
                        ))
                    }
                    
                    completion(course,nil)
                case .failure(let error):
                    completion(nil,error.localizedDescription)
                    print(error)
                    
                }
        }
        
    }
    
    class func getCourseBySearchName(courseName:String, completion : @escaping (_ courseList:[Course]?, _ errorMessage:String?) -> Void){
        var course = [Course]()
        
        if(courseName == ""){
            return
        }
        
        Alamofire.request(Network.IP_Address_Master+"/course?name=\(courseName)",method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                let result = json["response"]
                if(result["status"] == false){
                    print(result["message"])
                    completion(nil,result["message"].stringValue)
                    return
                }
                
                let courses = json["courses"]
                
                for obj in courses{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: this_course["categoryId"] == JSON.null ? -1 : this_course["categoryId"].intValue ,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"] != JSON.null ? this_course["createdDate"].stringValue : "0")!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                        img: "java"
                    ))
                }
                completion(course,nil)
            case .failure(let error):
                completion(nil,error.localizedDescription)
                print(error)
            }
        }
    }
    
    class func getCourseBySearchInstructor(instructorName:String, completion : @escaping (_ courseList:[Course]?, _ errorMessage:String?)-> Void){
        var course = [Course]()
        let url = "\(Network.IP_Address_Master)/course?teacherName=\(instructorName)"
        if(instructorName == ""){
            return
        }
        Alamofire.request(url,method: .get,encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case.success(let value):
                let json = JSON(value)
                
                let result = json["response"]
                if(result["status"] == false){
                    print(result["message"])
                    completion(nil,result["message"].stringValue)
                    return
                }
                
                let courses = json["courses"]
                for obj in courses{
                    let this_course = obj.1
                    course.append(Course(
                        id : Int(this_course["id"].stringValue)!,
                        categoryId: this_course["categoryId"] == JSON.null ? -1 : this_course["categoryId"].intValue,
                        detail: this_course["detail"].stringValue,
                        createdDate: Float(this_course["createdDate"] != JSON.null ? this_course["createdDate"].stringValue : "0")!,
                        key: this_course["key"].stringValue,
                        name : this_course["name"].stringValue,
                        owner: this_course["teacher"] != JSON.null ? "\(this_course["teacher"]["member"]["name"]) \(this_course["teacher"]["member"]["surname"])" : "",
                        img: "java"
                    ))
                }
                completion(course,nil)
            case.failure(let error):
                completion(nil,error.localizedDescription)
                print(error)
            }
        }
        
    }
        
    
}

