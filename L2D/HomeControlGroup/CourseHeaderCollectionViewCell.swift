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
    var img : UIImage?
    
    override func awakeFromNib() {
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        shadowBox.layer.shadowOpacity = 0.8
        shadowBox.layer.shadowRadius = 4
        //        self.addSubview(c_name)
        //        c_name.text = "Label"
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
                                        self.img_header_btn.setBackgroundImage(self.img, for: .normal)
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
            self.img_header_btn.setBackgroundImage(UIImage(named: img), for: .normal)
            self.img = UIImage(named: img)
        }
    }
    
    func initCell(img : String , id : Int) {
        self.img_header_btn.id = id
        if(self.img == nil){
            fetchImage(img: img)
        }else{
            self.img_header_btn.setBackgroundImage(self.img, for: .normal)
        }
    }
    
}
