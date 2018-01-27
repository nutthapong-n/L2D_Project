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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Course.getMyCourse{ (result) in
            self.courses = result
            //            self.homeTable.reloadInputViews()
            //            self.reloadInputViews()
            //            self.homeTable.reloadInputViews()
            self.homeTable.reloadData()
            print(result)
        }
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
        return 200
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
        
        cell.courseName.text = modelData.name
        cell.courseDetail.text = modelData.detail
        
        
        return cell
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

