//
//  SearchTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/27/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var content_container: UIView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var course_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content_container.layer.shadowColor = UIColor.black.cgColor
        content_container.layer.shadowOffset = CGSize(width:0, height:0)
        content_container.layer.shadowOpacity = 0.8
        content_container.layer.shadowRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
