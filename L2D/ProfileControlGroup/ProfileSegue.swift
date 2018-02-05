//
//  ProfileSeque.swift
//  L2D
//
//  Created by Magnus on 1/25/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class ProfileSegue: UIStoryboardSegue  {
    
    override func perform() {
            let toViewController = self.destination
            let fromViewController = self.source
            fromViewController.present(toViewController, animated: true, completion: nil)
    }
}
