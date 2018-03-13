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
    
    override func awakeFromNib() {
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        shadowBox.layer.shadowOpacity = 0.8
        shadowBox.layer.shadowRadius = 4
        //        self.addSubview(c_name)
        //        c_name.text = "Label"
    }
    
    func initCell(img : String ,id : Int) {
        img_header_btn.id = id
        if(img != "download"){
            Course.getfile(key: img, completion: { (path, error) in
                if(error == nil){
                    let url = "http://158.108.207.7:8080/\(path ?? "")"
                    self.img_header_btn.load(url: URL(fileURLWithPath: url))
                }else{
                    print(error!)
                }
                
            })
        }else{
            self.img_header_btn.setBackgroundImage(UIImage(named: img), for: .normal)
        }
        
        
    }
    
}
