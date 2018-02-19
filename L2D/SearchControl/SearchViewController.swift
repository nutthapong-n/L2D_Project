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
    var dataAry = [Course]()
    
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
                    self.myAlert(title: "Error", text: errMsg!)
                }else{
                    self.dataAry = result!
                    self.myTableView.reloadData()
                }
        
                refreshControl.endRefreshing()
            })
        }else if (searchBar.text != "" && searchBar.selectedScopeButtonIndex == 1) {
            Course.getCourseBySearchInstructor(instructorName: searchBar.text!, completion: {(result, errMsg) in
                if errMsg != nil {
                    self.myAlert(title: "Error", text: errMsg!)
                }else{
                    self.dataAry = result!
                    self.myTableView.reloadData()
                }
                
                refreshControl.endRefreshing()
            })
        }else{
            self.dataAry.removeAll()
            self.myTableView.reloadData()
            refreshControl.endRefreshing()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        myTableView.addSubview(refreshControl)
        

        // Do any additional setup after loading the view.
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
            self.dataAry.removeAll()
            self.myTableView.reloadData()
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
    func reloadData(type : Int , text : String){
        switch type {
        case 0:
            Course.getCourseBySearchName(courseName: text, completion: {(result, errMsg) in
                if errMsg != nil {
                    self.myAlert(title: "Error", text: errMsg!)
                }else{
                    self.dataAry = result!
                    self.myTableView.reloadData()
                }
            })
        case 1:
            Course.getCourseBySearchInstructor(instructorName: text, completion: {(result, errMsg) in
                if errMsg != nil {
                    self.myAlert(title: "Error", text: errMsg!)
                }else{
                    self.dataAry = result!
                    self.myTableView.reloadData()
                }
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
        return 150
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

        
        
        return cell
    }
    
    //add delegate method for pushing to new detail controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        vc.dataModel = dataAry[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

