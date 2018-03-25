//
//  CategoryTableViewController.swift
//  L2D
//
//  Created by Magnus on 2/4/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CourseCategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var CourseInCategoryTable: UITableView!
    @IBOutlet weak var TopBarTitle: UINavigationItem!
    
    
    var categoryName:String = "Category"
    var courseIdList = [Int]()
    var courseList = [Course]()
    var rowSelected:Int = -1
    var imgList : [Int:UIImage] = [:]
    


    
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
    
    override func viewDidLoad() {
        self.courseList.removeAll()
        self.CourseInCategoryTable.reloadData()
        
        if courseIdList != [Int]() {
            
            if courseIdList.count == 1 {
                Course.getCourseByCourseId(courseID: courseIdList[0], completion:{(result,errMsg) in
                    if errMsg != nil{
//                        self.myAlert(title: "Error", text: errMsg!)
                        print("Error : \(errMsg ?? "") in func:viewDidLoad")
                    }
                    else if result != nil {
                        self.courseList.append(result!)
                    }
                    self.CourseInCategoryTable.reloadData()
                })
            }
            else{
                Course.getCourseByCourseIdList(courseID: courseIdList, completion: {(result,errMsg) in
                    if errMsg != nil{
//                        self.myAlert(title: "Error", text: errMsg!)
                        print("Error : \(errMsg ?? "") in func:viewDidLoad")
                    }
                    else if result != nil{
                        self.courseList = result!
                    }
                    self.CourseInCategoryTable.reloadData()
                })
    
            }
        }
        self.TopBarTitle.title = categoryName
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if courseIdList != [Int]() {
//            self.courseList.removeAll()
//            for courseID in courseIdList {
//                Course.getCourseByCourseId(courseID: courseID, completion:{(result) in
//                    self.courseList.append(result)
//                    self.CourseInCategoryTable.reloadData()
//                })
//            }
//        }
//
//        self.TopBarTitle.title = categoryName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseInCategoryCell", for: indexPath) as! CourseInCategoryTableViewCell

        //Configure the cell...
        
        let data = courseList[indexPath.row]
        var thisCourseImg = self.imgList[data.id]
        
        if(thisCourseImg == nil){
            Course.fetchImgByURL(picUrl: data.imgPath, completion: { (myImage) in
                self.imgList[data.id] = myImage
                cell.course_img.image = myImage
            })
            thisCourseImg = UIImage(named: "download")
        }
        
        cell.CourseNameLabel.text = data.name
//        cell.CourseDetailLabel.text = data.detail
        cell.CourseInstructor.text = data.owner
        cell.selectionStyle = .none
        cell.course_rating.settings.updateOnTouch = false
        cell.course_rating.rating = data.rating
        
        let rateText = "\(data.rating) from \(data.rateCount) vote"
        let rateCount = data.rateCount
        cell.course_rating.text = rateCount > 1 ? "\(rateText)s" : rateText
        
//        cell.ratingBar.rating = (self.course?.rating)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rowSelected = indexPath.row
        let desView = storyboard?.instantiateViewController(withIdentifier: "CourseControllorBoard") as! CourseContentViewController
        desView.courseId = courseList[indexPath.row].id
        print(desView.courseId as Any)
        
        navigationController?.pushViewController(desView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
