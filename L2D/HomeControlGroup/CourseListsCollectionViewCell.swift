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
    
    func initCell(img : String , name : String , id : Int) {
        if(self.c_name != nil){
            self.c_name.text = " \(name)"
            self.img_btn.id = id
        }
        
        if(img != "download"){
            Course.getfile(key: img, completion: { (path, error) in
                if(error == nil){
                    let url = "http://158.108.207.7:8080/\(path ?? "")"
                    self.img_btn.load(url: URL(fileURLWithPath: url))
                    self.img_btn.setima
                }else{
                    print(error!)
                }
                
            })
        }else{
            self.img_btn.setBackgroundImage(UIImage(named: img), for: .normal)
        }
        

        
    }
    
}
