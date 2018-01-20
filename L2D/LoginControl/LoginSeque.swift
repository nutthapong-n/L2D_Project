//
//  LoginSeque.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/26/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire;
import SwiftyJSON;

class LoginSeque: UIStoryboardSegue  {
    
    var username : String?
    var password: String?
    
    override func perform() {
        let toViewController = self.destination
        let fromViewController = self.source
        
//        let headers: HTTPHeaders = [
//            "Accept": "application/json"
//        ]
        let parameters: Parameters = ["mname" : "barlay",
                                      "msurname" : "first",
                                      "musername" : "meejansumit",
                                      "mpassword" : "mit0805813950",
                                      "mprofile" : "xxe",
                                      "memail" : "first927@live.com"]
        
        print("before send");
        
        
        Alamofire.request("http://158.108.207.7:8090/elearning/member/add",method : .post, parameters : parameters , encoding: JSONEncoding.default)
            .responseJSON{

                response in
                print(response)
                if let value = response.result.value{
                    let json = JSON(value)
                    print("login to e_learning system");
                    print(json)
                    print(response.request)
                }
        }
        
//        fromViewController.present(toViewController, animated: true, completion: nil)
        
        
    }
}
