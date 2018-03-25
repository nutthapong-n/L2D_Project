//
//  CourseListsCollectionViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/24/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos
import Imaginary

class CourseListsCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var img_btn: HomeCellButton!
    @IBOutlet weak var shadowBox: UIView!
    @IBOutlet weak var c_name: UILabel!
    @IBOutlet weak var course_rating: CosmosView!
    var img : UIImage?
    
    
    override func awakeFromNib() {
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        shadowBox.layer.shadowOpacity = 0.8
        shadowBox.layer.shadowRadius = 4
//        self.addSubview(c_name)
//        c_name.text = "Label"
    }
    
    @IBAction func open_cause(_ sender: UIButton) {

    }
    
    func initCell(img : UIImage , name : String , id : Int) {
        if(self.c_name != nil){
            self.c_name.text = " \(name)"
            self.img_btn.id = id
        }
        self.img_btn.setBackgroundImage(img, for: .normal)
        

    }
    
}
