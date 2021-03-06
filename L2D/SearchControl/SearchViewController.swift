//
//  SearchViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

enum selectedScope:Int {
    case name = 0
    case owner = 1
}

class SearchViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate, UIScrollViewDelegate{
    
    
    let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
    var initialDataAry:[Course] = Course.generateModelArray()
    var dataAry = [CourseWithImgPath]()
    var imgList : [Int:UIImage] = [:]
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var barContainerTable: UITableView!
    @IBOutlet weak var content_container: UIView!
    
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
        if (searchBar.text != "" && searchBar.selectedScopeButtonIndex == 0) {
            Course.getCourseBySearchName(courseName: searchBar.text!, completion: {(result, errMsg) in
                if(errMsg != nil){
//                    self.myAlert(title: "Error", text: errMsg!)
                    self.myAlert(title: "Not found", text: "")
                    self.dataAry.removeAll()
                    self.imgList.removeAll()
                    print("Error : \(errMsg ?? "from func actualizarDators")")
                }else{
                    self.dataAry = result!
                    
                }
                self.myTableView.reloadData()
                refreshControl.endRefreshing()
            })
        }else if (searchBar.text != "" && searchBar.selectedScopeButtonIndex == 1) {
            Course.getCourseBySearchInstructor(instructorName: searchBar.text!, completion: {(result, errMsg) in
                if errMsg != nil {
//                    self.myAlert(title: "Error", text: errMsg!)
                    self.myAlert(title: "Not found", text: "")
                    self.dataAry.removeAll()
                    self.imgList.removeAll()
                    print("Error : \(errMsg ?? "from func actualizarDators")")
                }else{
                    self.dataAry = result!
                    
                }
                self.myTableView.reloadData()
                refreshControl.endRefreshing()
            })
        }else{
//            self.dataAry.removeAll()
//            self.myTableView.reloadData()
            reloadData(type: 2, text: "")
            refreshControl.endRefreshing()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        myTableView.addSubview(refreshControl)
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
//        view.addGestureRecognizer(tap)
        
        reloadData(type: 2, text: "")
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func searchBarSetup() {
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name","Instructor"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.placeholder = "find course"
        searchBar.endEditing(true)
        searchBar.isOpaque = true
        searchBar.barTintColor = UIColor(red:0.87, green:0.93, blue:0.93, alpha:0.1)
        searchBar.tintColor = UIColor(red:0.02, green:0.34, blue:0.34, alpha:1)
        searchBar.delegate = self
        self.barContainerTable.tableHeaderView = searchBar    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desView = segue.destination as! CourseContentViewController
        let courseCell = sender as! SearchTableViewCell
        desView.courseId = courseCell.id
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
//        Course.getCourseBySearchName(courseName: <#T##String#>, completion: <#T##([Course]) -> Void#>)
        print("trues --------")
        searchBar.endEditing(true)

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing")
        if (searchBar.text != "" && searchBar.selectedScopeButtonIndex == 0) {
            reloadData(type: 0, text: searchBar.text!)
            print("search by course name")
        }else if (searchBar.text != "" && searchBar.selectedScopeButtonIndex == 1) {
            reloadData(type: 1, text: searchBar.text!)
            print("search by instructor name")
        }else{
//            self.dataAry.removeAll()
//            self.myTableView.reloadData()
            reloadData(type: 2, text: "")
            print("Get All")
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
//        dataAry = initialDataAry
        self.myTableView.reloadData()
        
    }
    
    ///
    /// - Parameter type: 0 is course name
    ///                   1 is instructor name
    ///                   2 is get all courses
    func reloadData(type : Int , text : String){
        switch type {
        case 0:
            Course.getCourseBySearchName(courseName: text, completion: {(result, errMsg) in
                if errMsg != nil {
//                    self.myAlert(title: "Error", text: errMsg!)
                    self.myAlert(title: "Not found", text: "")
                    print("Error : \(errMsg ?? "from func:reload data / get course by search name")")
                    self.dataAry.removeAll()
                }else{
                    self.dataAry = result!
                    
                }
                self.myTableView.reloadData()
            })
        case 1:
            Course.getCourseBySearchInstructor(instructorName: text, completion: {(result, errMsg) in
                if errMsg != nil {
//                    self.myAlert(title: "Error", text: errMsg!)
                    self.myAlert(title: "Not found", text: "")
                    print("Error : \(errMsg ?? "from func:reload data / get course by search instuctor")")
                    self.dataAry.removeAll()
                }else{
                    self.dataAry = result!
                    
                }
                self.myTableView.reloadData()
            })
        case 2:
            Course.getAllCourse(completion: { (result, errMsg) in
                if(errMsg != nil){
                    print(errMsg!)
//                    self.dataAry.removeAll()
                }else{
                    self.dataAry = result!
                }
                self.myTableView.reloadData()
            })
            
        default:
            print("in other case")
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            reloadData(type: 0, text: searchBar.text!)
        case 1:
            reloadData(type: 1, text: searchBar.text!)
        default:
            print("no type")
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "searchList_cell", for: indexPath) as! SearchTableViewCell
        
        let model = dataAry[indexPath.row]
        
        cell.id = model.id
        cell.cellLabel.text = model.name
        cell.ownerLabel.text = "Instructor: \(model.owner)"
        cell.course_star.settings.updateOnTouch = false
        cell.course_star.settings.fillMode = .precise
        let rateText = "\(model.rating) from \(model.rateCount) vote"
        let rateCount = model.rateCount
        cell.course_star.text = rateCount > 1 ? "\(rateText)s" : rateText
        cell.course_star.rating = model.rating
        
        if(self.imgList[cell.id!] == nil){
            print("send \(model.imgPath)")
            Course.fetchImgByURL(picUrl: model.imgPath, completion: { (myImage) in
                if(myImage != nil){
                    self.imgList[cell.id!] = myImage
                    DispatchQueue.main.async {
                        cell.course_img.image = self.imgList[cell.id!]
                    }
                }else{
                    self.imgList[cell.id!] = UIImage(named: "download")
                }
            })
            self.imgList[cell.id!] = UIImage(named: "loading")
        }
        
        cell.course_img.image = self.imgList[cell.id!]

        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Get all
//        reloadData(type: 2, text: "")
    }
    
    //add delegate method for pushing to new detail controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseControllorBoard") as! CourseContentViewController
////        vc.dataModel = dataAry[indexPath.row]
//        vc.courseId = dataAry[indexPath.row].id
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

