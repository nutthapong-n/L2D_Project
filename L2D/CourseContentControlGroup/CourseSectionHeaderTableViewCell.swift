//
//  CourseSectionHeaderTableViewCell.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 29/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos
import GradientProgressBar

class CourseSectionHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var enroll_btn : UIButton!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var rate_btn: UIButton!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    // set path PDF
//    let remotePDFDocumentURLPath = "http://myweb.sabanciuniv.edu/rdehkharghani/files/2016/02/The-Morgan-Kaufmann-Series-in-Data-Management-Systems-Jiawei-Han-Micheline-Kamber-Jian-Pei-Data-Mining.-Concepts-and-Techniques-3rd-Edition-Morgan-Kaufmann-2011.pdf"
    
//    let remotePDFDocumentURL = URL(string: "http://myweb.sabanciuniv.edu/rdehkharghani/files/2016/02/The-Morgan-Kaufmann-Series-in-Data-Management-Systems-Jiawei-Han-Micheline-Kamber-Jian-Pei-Data-Mining.-Concepts-and-Techniques-3rd-Edition-Morgan-Kaufmann-2011.pdf")!
    
//    let document = PDFDocument(url: URL(string: "http://myweb.sabanciuniv.edu/rdehkharghani/files/2016/02/The-Morgan-Kaufmann-Series-in-Data-Management-Systems-Jiawei-Han-Micheline-Kamber-Jian-Pei-Data-Mining.-Concepts-and-Techniques-3rd-Edition-Morgan-Kaufmann-2011.pdf")!)!
    
//    @IBOutlet weak var showPDF: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressBar.gradientColorList = [
            UIColor(hex: "#F86B00"),
            UIColor(hex: "#F86B00")
        ]
        progressBar.setProgress(0, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
