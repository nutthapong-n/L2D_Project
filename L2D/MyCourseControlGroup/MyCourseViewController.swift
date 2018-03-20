//
//  MyCourseViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class MyCourseViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var homeTable: UITableView!
//    var detail = ["New course" ,"Reccommend","In Trend"]
    var detail = ["My Course"]
//    var courses:[Course] = Course.generateModelArray()
//    var allMyCourse:[Course] = Course.getMyCourse()
    var courses:[Course] = []
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(actualizarDators) , for: .valueChanged)
        rc.tintColor = UIColor.black
        return rc
    }()
    
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
    
    @objc func actualizarDators(_ refreshControl : UIRefreshControl){
        Course.getMyCourse{ (result,errMsg) in
            if(errMsg != nil){
//                self.myAlert(title: "Error", text: errMsg!)
                print("Error : \(errMsg ?? "") in func:actualizarDators")
            }else{
                self.courses = result!
                self.homeTable.reloadData()
            }

            refreshControl.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTable.addSubview(self.refreshControl)
        Course.getMyCourse{ (result,errMsg) in
            if(errMsg != nil){
//                self.myAlert(title: "Error", text: errMsg!)
                print("Error : \(errMsg ?? "") in func:viewDidLoad")
            }else{
                self.courses = result!
                self.homeTable.reloadData()
            }
//            print(result)
        }
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_list" , for: indexPath) as! MyCourseTableViewCell

//        cell.textLabel?.numberOfLines = 0
//
//        var label : String?
//
//        label = detail[indexPath.row];
//
//        cell.header_btn.setTitle(label, for: .normal)
        
        let modelData = courses[indexPath.row]
        
        
        cell.course_img.setImage(url: URL(string: modelData.img)!)
        cell.courseName.text = modelData.name
//        cell.courseDetail.text = modelData.detail
        cell.instructorName.text = "Instructor : \(modelData.owner)"
        cell.selectionStyle = .none
        cell.ratingBar.settings.updateOnTouch = false
        cell.ratingBar.settings.fillMode = .precise
        
        let rateText = "\(modelData.rating) from \(modelData.rateCount) vote"
        let rateCount = modelData.rateCount
        cell.ratingBar.text = rateCount > 1 ? "\(rateText)s" : rateText
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let desView = storyboard?.instantiateViewController(withIdentifier: "CourseControllorBoard") as! CourseContentViewController
        desView.courseId = courses[indexPath.row].id
        
        navigationController?.pushViewController(desView, animated: true)
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
//extension MyCourseViewController : UICollectionViewDataSource , UICollectionViewDelegate{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return courses.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course_list", for: indexPath) as! MyCourseCollectionViewCell
//
//        let course = courses[indexPath.row]
//
//        cell.img_btn.setBackgroundImage(UIImage(named: course.img), for: .normal)
//        cell.shadowBox.layer.shadowColor = UIColor.black.cgColor
//        cell.shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
//        cell.shadowBox.layer.shadowOpacity = 0.8
//        cell.shadowBox.layer.shadowRadius = 4
//
//        return cell
//    }
//
//
//
//}

