//
//  RegisterSeque.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 22/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterSeque: UIStoryboardSegue {
    
    var regis_success : Bool?
    var parameters : Parameters?
    
    override func perform() {
        if(parameters?.count != 0){
            Alamofire.request("http://192.168.43.236:8090/elearning/member/add",method : .post, parameters : parameters , encoding: JSONEncoding.default)
                .responseJSON{
                    
                    response in switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        if(json != nil){
                            AppDelegate.hasLogin = true;
                            let toViewController = self.destination
                            let fromViewController = self.source
                            fromViewController.present(toViewController, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
            

        }
    }

}
