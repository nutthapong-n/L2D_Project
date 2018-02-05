//
//  HomeViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController ,UITableViewDelegate , UITableViewDataSource{
    

    var course:[Course]?
    var detail = ["New course" ,"Reccommend","In Trend"]
    var selectedId : Int = 0
    
    @IBOutlet weak var homeTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        super.loadView()
        Course.getAllCourse { (result) in
            self.course = result
//            self.homeTable.reloadInputViews()
//            self.reloadInputViews()
//            self.homeTable.reloadInputViews()
            self.homeTable.reloadData()
//            print(result)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let course_segue = segue as! CoursePreviewSegue
        
        if(segue.identifier == "sideBar"){
            
        }else{
            let sender = sender as! HomeCellButton
            let desView = segue.destination as! CourseContentViewController
            desView.courseId = sender.id
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
           let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_head_list" , for: indexPath) as! HomeHeaderTableViewCell
            cell.MyCollecttionView.reloadData()
            
            cell.textLabel?.numberOfLines = 0
            
            
            let itemWidth =  view.frame.width
            let itemHeight = cell.MyCollecttionView.frame.height
            let layout = UICollectionViewFlowLayout()
            
            layout.itemSize = CGSize(width:itemWidth, height:itemHeight)
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            cell.MyCollecttionView.collectionViewLayout = layout
            
            return cell
        }else{

           let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_list" , for: indexPath) as! CourseListsTableViewCell
            cell.MyCollecttionView.reloadData()
            
            var label : String?
            
            label = detail[indexPath.row];
            cell.header_btn.setTitle(label, for: .normal)
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        
        
        
        
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

enum CellError: Error {
    case CanNotCast
    case NoNumber
    case CustomMessage(message: String)
}

extension HomeViewController : UICollectionViewDataSource , UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(course == nil){
            return 0;
        }else{
            return course!.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course_list", for: indexPath) as! CourseListsCollectionViewCell
            
        let thisCourse = course![indexPath.row]
//        cell.img_btn.initId(id: thisCourse.id)
        cell.initCell(img: thisCourse.img, name: thisCourse.name , id : thisCourse.id)
        
        
            return cell
            
        
    }
    
    
    
}

