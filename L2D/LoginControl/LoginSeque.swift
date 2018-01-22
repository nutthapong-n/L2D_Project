//
//  LoginSeque.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/26/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class LoginSeque: UIStoryboardSegue  {
    
    var login_success : Bool? = false;
    
    override func perform() {
        

        
        if(login_success)!{
            let toViewController = self.destination
            let fromViewController = self.source
            fromViewController.present(toViewController, animated: true, completion: nil)
        }
        
        
        
    }
}
