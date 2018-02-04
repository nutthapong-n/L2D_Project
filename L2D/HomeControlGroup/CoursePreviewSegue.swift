//
//  CoursePreviewSegue.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 30/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CoursePreviewSegue: UIStoryboardSegue {

    override func perform() {
        let toViewController = self.destination
        let fromViewController = self.source
        fromViewController.present(toViewController, animated: true, completion: nil)
    }
}
