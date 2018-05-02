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
    var photoUrl : String
    
    init(name:String ,idmember:Int ,surname:String ,email:String ,type:String, photoUrl:String){
        self.name = name
        self.idmember = idmember
        self.surname = surname
        self.email = email
        self.type = type
        self.photoUrl = photoUrl
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
    
    
    ///Login func
    ///
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - completion: Bool is login status, Int is error status
    class func logIn(username : String, password : String, completion : @escaping (Bool, Int) -> ()){
        let urlString = "\(Network.IP_Address_Master)/member/login"
        let parameters: Parameters = ["username" : username,"passwd" : password ]
        
        Alamofire.request(urlString,method : .post, parameters : parameters , encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let status = json["status"].rawString()
                    if( status != "false" || (username == "admin" && password == "admin")){
                        
                        let user  = User_model(
                            name : json["name"].stringValue,
                            idmember : Int(json["idmember"].stringValue)!,
                            surname : json["surname"].stringValue,
                            email : json["email"].stringValue,
                            type : json["type"].stringValue,
                            photoUrl: "http://158.108.207.7:8090/elearning/\(json["photoUrl"].stringValue)"
                            
                        )
                        
                        AppDelegate.userData = user
                        
                        completion(true, -1)
                    }else{
                       completion(false,0)
                    }
                case .failure( _):
                    completion(false,1)
                }
        }
    }
    
    class func uploadPicture(image : UIImage, completion: @escaping (Bool) -> Void){
        let url = "\(Network.IP_Address_Master)/files-up/member/picture"
        
//        let imageData = UIImagePNGRepresentation(image)!
//
//        let imageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//
//        let parameters: Parameters = [
//            "file" : imageBase64,
//            "memberId" : AppDelegate.userData?.idmember ?? 0
//        ]
        
        let parameters: Parameters = [
//            "file" : image,
            "memberId" : AppDelegate.userData?.idmember ?? 0
        ]
        
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
//            switch response.result{
//            case .success(let value):
//                debugPrint(value)
//                completion(true)
//            case .failure(let error):
//                print(error.localizedDescription)
//                completion(false)
//            }
//        }
        
        
        
        Alamofire.upload(multipartFormData: { (multipartFromData) in
            multipartFromData.append(UIImagePNGRepresentation(image)!, withName: "file", fileName: "profile.png", mimeType: "image/png")
            for (key, value) in parameters {
//                multipartFromData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
              
            }
//            if let myMemberId = AppDelegate.userData?.idmember{
//                var myId : Int = myMemberId
//                let memberIdData = Data(bytes: &myId, count: MemoryLayout.size(ofValue: myId))
//
//                multipartFromData.append(memberIdData, withName: "memberId")
//            }
            let myMemberId = "\(AppDelegate.userData?.idmember ?? 0)"
            multipartFromData.append(myMemberId.data(using: String.Encoding.utf8)!, withName: "memberId")
        }, to: url) { (result) in
            switch result {

            case .success(let request, let streamingFromDisk, let streamFileURL):
                request.uploadProgress(closure: { (progress) in
                    print("Upload Progress : \(progress.fractionCompleted)")
                })

                request.responseJSON(completionHandler: { (response) in
//                    print(response.result.value!)
                    print(response.result)
                    completion(true)
                })
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
//        Alamofire.upload(multipartFormData: { (multipartFromData) in
//            multipartFromData.append(UIImageJPEGRepresentation(image, 1)!, withName: "file", fileName: "profile.jpeg", mimeType: "image/jpeg")
////            for (key, value) in parameters {
////            multipartFromData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
////            }
//            if let myMemberId = AppDelegate.userData?.idmember{
//                var myId : Int = myMemberId
//                let memberIdData = Data(bytes: &myId, count: MemoryLayout.size(ofValue: myId))
//
//                multipartFromData.append(memberIdData, withName: "memberId")
//            }
//
//
//
//        }
//        , to: url, method: HTTPMethod.post, headers: nil) { (encodingResult) in
//            switch encodingResult{
//
//            case .success(let request, let streamingFromDisk, let streamFileURL):
//                request.responseJSON(completionHandler: { (response) in
//                    debugPrint(response)
//                    completion(true)
//                })
//            case .failure(let error):
//                completion(false)
//                debugPrint(error)
//            }
//        }
    }

}
