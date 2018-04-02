//
//  MyCourseTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/27/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos
import GradientProgressBar

class MyCourseTableViewCell: UITableViewCell {
    
    
//    @IBOutlet weak var header_btn: UIButton!
//    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    @IBOutlet weak var content_container: UIView!
    @IBOutlet weak var courseName: UILabel!
//    @IBOutlet weak var courseDetail: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    @IBOutlet weak var course_img: UIImageView!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content_container.layer.shadowColor = UIColor.black.cgColor
        content_container.layer.shadowOffset = CGSize(width:0, height:0)
        content_container.layer.shadowOpacity = 0.8
        content_container.layer.shadowRadius = 4
        
        progressBar.gradientColorList = [
            UIColor(hex: "#F86B00"),
            UIColor(hex: "#F86B00")
        ]
        progressBar.setProgress(0, animated: true)
        

//        progressBar.setProgress(0.75, animated: true)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
