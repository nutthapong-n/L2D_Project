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
    var img : UIImage?
    
    
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
    
    func fetchImage(img : String){
        if(img != "download"){
            Course.getfile(key: img, completion: { (path, error) in
                if(error == nil){
                    
                    let url = URL(string: "http://158.108.207.7:8080/\(path ?? "")")
                    
                    let session = URLSession(configuration: .default)
                    
                    //creating a dataTask
                    let getImageFromUrl = session.dataTask(with: url!) { (data, response, error) in
                        
                        //if there is any error
                        if let e = error {
                            //displaying the message
                            print("Error Occurred: \(e)")
                            
                        } else {
                            //in case of now error, checking wheather the response is nil or not
                            if (response as? HTTPURLResponse) != nil {
                                
                                //checking if the response contains an image
                                if let imageData = data {
                                    
                                    //getting the image
                                    self.img = UIImage(data: imageData)
                                    
                                    //displaying the image
                                    DispatchQueue.main.async { // Correct
                                        self.img_btn.setBackgroundImage(self.img, for: .normal)
                                    }
                                    
                                    //                                    self.uiImageView.image = image
                                    
                                } else {
                                    print("Image file is currupted")
                                }
                            } else {
                                print("No response from server")
                            }
                        }
                    }
                    
                    //starting the download task
                    getImageFromUrl.resume()
                    
                    
                }else{
                    print(error!)
                }
                
            })
        }else{
            self.img_btn.setBackgroundImage(UIImage(named: img), for: .normal)
            self.img = UIImage(named: img)
        }
    }
    
    func initCell(img : String , name : String , id : Int) {
        if(self.c_name != nil){
            self.c_name.text = " \(name)"
            self.img_btn.id = id
        }
        
        if(self.img == nil){
            fetchImage(img: img)
        }else{
            self.img_btn.setBackgroundImage(self.img, for: .normal)
        }
    }
    
}
