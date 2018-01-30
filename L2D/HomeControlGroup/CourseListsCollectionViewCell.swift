//
//  CourseListsCollectionViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/24/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseListsCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var img_btn: UIButton!
    @IBOutlet weak var shadowBox: UIView!
    @IBOutlet weak var c_name: UILabel!

    
    override func awakeFromNib() {
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        shadowBox.layer.shadowOpacity = 0.8
        shadowBox.layer.shadowRadius = 4
//        self.addSubview(c_name)
//        c_name.text = "Label"
    }
    
    
    func initCell(img : String , name : String) {
        self.img_btn.setBackgroundImage(UIImage(named: img), for: .normal)
        if(self.c_name != nil){
            self.c_name.text = " \(name)"
        }
        
    }
    
}
