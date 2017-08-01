//
//  CourseListsTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/24/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseListsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var header_btn: UIButton!
    @IBOutlet weak var MyCollecttionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
