//
//  RateCourseViewController.swift
//  L2D
//
//  Created by Magnus on 3/20/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos

class RateCourseViewController: UIViewController {

    var userRating : Double = 0.0
    var courseId : Int = 0
    
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func myAlert(title : String,text : String){
        self.resignFirstResponder()
        let alert = UIAlertController(title:title,message: text, preferredStyle: .alert)
        
        let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
      
            self.navigationController?.popViewController(animated: true)
            
            
        })
        
        alert.addAction(dismissBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func comfirmClicked(_ sender: UIButton) {
        Course.rateCourse(CourseId: courseId, memberId: (AppDelegate.userData?.idmember)!, rating: ratingBar.rating){ (result, avgRating) in
            if(result){
//                self.navigationController?.popViewController(animated: true)
                
//                if let allView = self.navigationController?.viewControllers{
//                    let previousView = allView[allView.count - 2] as! CourseContentViewController
//                    previousView.userRating = self.ratingBar.rating
//                    let tbHeader = previousView.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
//                    tbHeader.ratingBar.rating = avgRating!
//                }
                self.myAlert(title: "Rated!", text: "")
            }else{
              self.myAlert(title: "Failed!", text: "Something went wrong.")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ratingBar.settings.fillMode = .half
        ratingBar.rating = userRating
        
        if(userRating != 0.0){
            topLabel.text = "Your last rating is \(userRating)"
            topLabel.isHidden = false
        }else{
//            topLabel.isHidden = true
            topLabel.text = "RATE THIS!"
        }
        
        bottomLabel.text = "Rate this course for \(userRating)?"
        
        ratingBar.didFinishTouchingCosmos = { rating in
            self.bottomLabel.text = "Rate this course for \(rating)?"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
