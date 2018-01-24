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
    
    var regis_success : Bool? = false
    
    
    override func perform() {
        if(regis_success == true){
            let toViewController = self.destination
            let fromViewController = self.source
            fromViewController.present(toViewController, animated: true, completion: nil)

        }
    }

}
