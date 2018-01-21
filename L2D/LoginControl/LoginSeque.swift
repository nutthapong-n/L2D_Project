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
        
        fromViewController.present(toViewController, animated: true, completion: nil)
        
        
    }
}
