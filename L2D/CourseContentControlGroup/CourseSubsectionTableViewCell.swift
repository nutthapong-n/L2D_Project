//
//  CourseSubsectionTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 30/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseSubsectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name_label: UILabel!
    var Subsection_id : Int?
    var name : String?
    var fileKey : String?
    var fileType : fileType?
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
