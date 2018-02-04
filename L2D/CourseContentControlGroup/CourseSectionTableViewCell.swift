//
//  CourseSectionTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 30/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseSectionTableViewCell: UITableViewCell {
    
    var section_id : Int?
    var subSection_id : [Int] = []
    var expandsion : Bool = false
    @IBOutlet weak var sec_img: UIImageView!
    @IBOutlet weak var sec_label: UILabel!
    @IBOutlet weak var expand_img : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
