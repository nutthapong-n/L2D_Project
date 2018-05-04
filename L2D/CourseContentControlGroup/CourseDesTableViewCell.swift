//
//  CourseDesTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 29/4/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CourseDesTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var des_text: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
    }

}
