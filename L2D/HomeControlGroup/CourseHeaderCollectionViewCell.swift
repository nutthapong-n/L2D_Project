//
//  CourseHeaderCollectionViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 6/2/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseHeaderCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var img_header_btn: HomeCellButton!
    @IBOutlet weak var shadowBox: UIView!
    var img : UIImage?
    
    override func awakeFromNib() {
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        shadowBox.layer.shadowOpacity = 0.8
        shadowBox.layer.shadowRadius = 4
        //        self.addSubview(c_name)
        //        c_name.text = "Label"
    }
    
    func initCell(img : UIImage , id : Int) {
        self.img_header_btn.id = id
        self.img_header_btn.setBackgroundImage(img, for: .normal)
    }
    
}
