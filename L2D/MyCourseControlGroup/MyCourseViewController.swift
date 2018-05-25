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
    @IBOutlet weak var myCourseTab: UISegmentedControl!
    var detail = ["My Course"]
//    var courses:[Course] = []
    var completeCourse:[Course] = []
    var currentCourse:[Course] = []
    
    var imgList : [Int:UIImage] = [:]
    
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
                self.completeCourse.removeAll()
                self.currentCourse.removeAll()
                for course in result!{
                    if(course.percentProgress == 100){
                        self.completeCourse.append(course)
                    }else{
                        self.currentCourse.append(course)
                    }
                }
                self.homeTable.reloadData()
            }

            refreshControl.endRefreshing()
        }
    }
    
    @objc func chageTab(){
        self.homeTable.reloadData()
//        self.homeTable.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set sub view
        self.homeTable.addSubview(self.refreshControl)
        myCourseTab.addTarget(self, action: #selector(chageTab), for: UIControlEvents.valueChanged)
        
        
        Course.getMyCourse{ (result,errMsg) in
            if(errMsg != nil){
                //                self.myAlert(title: "Error", text: errMsg!)
                print("Error : \(errMsg ?? "") in func:viewDidLoad")
            }else{
                self.completeCourse.removeAll()
                self.currentCourse.removeAll()
                for course in result!{
                    if(course.percentProgress == 100){
                        self.completeCourse.append(course)
                    }else{
                        self.currentCourse.append(course)
                    }
                }
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
        if(myCourseTab.selectedSegmentIndex == 0){
            return currentCourse.count
        }else{
            return completeCourse.count
        }
//        return courses.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let modelData : Course
        if(myCourseTab.selectedSegmentIndex == 0){
            modelData = self.currentCourse[indexPath.row]
        }else{
            modelData = self.completeCourse[indexPath.row]
        }
        
        let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_list" , for: indexPath) as! MyCourseTableViewCell
        
        
        
        let thisCourseImg = imgList[modelData.id]
        
        if(thisCourseImg == nil){
            Course.fetchImgByURL(picUrl: modelData.imgPath, completion: { (myImage) in
                if(myImage != nil){
                    self.imgList[modelData.id] = myImage
                    DispatchQueue.main.async {
                        cell.course_img.image = myImage
                    }
                }else{
                    self.imgList[modelData.id] = UIImage(named: "download")
                }
            })
            self.imgList[modelData.id] = cell.course_img.image
        }else{
            cell.course_img.image = thisCourseImg
        }
        
        
        cell.courseName.text = modelData.name
        cell.instructorName.text = "Instructor : \(modelData.owner)"
        cell.selectionStyle = .none
        cell.ratingBar.settings.updateOnTouch = false
        cell.ratingBar.settings.fillMode = .precise
        
        cell.progressBar.setProgress(modelData.percentProgress / 100, animated: true)
        
        let rateText = "\(modelData.rating) from \(modelData.rateCount) vote"
        let rateCount = modelData.rateCount
        cell.ratingBar.text = rateCount > 1 ? "\(rateText)s" : rateText
        cell.ratingBar.rating = modelData.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let desView = storyboard?.instantiateViewController(withIdentifier: "CourseControllorBoard") as! CourseContentViewController
        if(myCourseTab.selectedSegmentIndex == 0){
            desView.courseId = self.currentCourse[indexPath.row].id
        }else{
            desView.courseId = self.completeCourse[indexPath.row].id
        }
        
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

