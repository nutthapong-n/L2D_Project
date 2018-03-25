//
//  CourseInCategoryTableViewCell.swift
//  L2D
//
//  Created by Magnus on 2/4/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos

class CourseInCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var CourseNameLabel: UILabel!
//    @IBOutlet weak var CourseDetailLabel: UILabel!
    @IBOutlet weak var ItemViewBox: UIView!
    @IBOutlet weak var course_rating: CosmosView!
    @IBOutlet weak var CourseInstructor: UILabel!
    @IBOutlet weak var course_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ItemViewBox.layer.shadowColor = UIColor.black.cgColor
        ItemViewBox.layer.shadowOffset = CGSize(width:0, height:0)
        ItemViewBox.layer.shadowOpacity = 0.8
        ItemViewBox.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
