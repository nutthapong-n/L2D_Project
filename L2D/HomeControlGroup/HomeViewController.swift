//
//  HomeViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController ,UITableViewDelegate , UITableViewDataSource{
    

//    var course:[Course]?
    var courses : [String : [Course]] = [
//        "slide" : [],
        "new" : [],
        "top" : []
    ]
    var imgList : [Int:UIImage] = [:]
    var ownerImgList : [Int:UIImage] = [:]
    var courseSaparator : [Course] = []
    var detail = ["New Courses","Top Courses"]
    var SlideShowcount = 0
    var currentRow = 0
//    var headerCell : HomeHeaderTableViewCell?
    var helloWorldTimer : Timer?
    
//    @objc func sayHello()
//    {
//        currentRow = 0
//        SlideShowcount += 1
//
//        let collecttion = headerCell?.MyCollecttionView
//
//        if  SlideShowcount  == courses["slide"]?.count
//        {
//            SlideShowcount = 0
//        }
//
//        collecttion?.scrollToItem(at: IndexPath(item: SlideShowcount, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
//
//    }
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(actualizarDators) , for: .valueChanged)
        rc.tintColor = UIColor.black
        return rc
    }()
    @IBOutlet weak var homeTable: UITableView!
    
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
        var TopSuccess : Bool = false
        var NewSuccess : Bool = false
        
        Course.getTopCourse(amount: 8) { (result,errMsg) in
            TopSuccess = true
            self.imgList.removeAll()
            if(errMsg != nil){
                self.myAlert(title: "Error", text: errMsg!)
            }else{
//                self.courses["slide"] = result
                self.courses["top"] = result
                self.homeTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
            if(NewSuccess && TopSuccess){
                refreshControl.endRefreshing()
            }
            //            print(result)
        }
        
        Course.getNewCourse(amount: 8) { (result,errMsg) in
            NewSuccess = true
            self.imgList.removeAll()
            if(errMsg != nil){
//                self.myAlert(title: "Error", text: errMsg!)
                print("Error : \(errMsg ?? "") in func:actualizarDators")
            }else{
                self.courses["new"] = result
                self.homeTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            }
            if(NewSuccess && TopSuccess){
                refreshControl.endRefreshing()
            }
            //            print(result)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTable.addSubview(self.refreshControl)

    }
    
    override func loadView() {
        super.loadView()
        var TopSuccess : Bool = false
        var NewSuccess : Bool = false
        Course.getTopCourse(amount: 8) { (result,errMsg) in
            
            if(errMsg != nil){
                self.myAlert(title: "Error", text: errMsg!)
            }else{
                self.courses["top"] = result
//                self.homeTable.reloadData()
                
            }
            TopSuccess = true
            if(NewSuccess && TopSuccess){
               self.homeTable.reloadData()
            }
            
            //            print(result)
        }
        
        Course.getNewCourse(amount: 8) { (result,errMsg) in
            
            if(errMsg != nil){
//                self.myAlert(title: "Error", text: errMsg!)
                print("Error : \(errMsg ?? "") in func:loadView")
            }else{
                self.courses["new"] = result
//                self.homeTable.reloadData()
            }
            NewSuccess = true
            if(NewSuccess && TopSuccess){
                self.homeTable.reloadData()
            }
            
            //            print(result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(AppDelegate.reLoadRequest != nil){
            AppDelegate.reLoadRequest = nil
            let tabBar = self.tabBarController as! MainTabViewController
            if(AppDelegate.hasLogin == true && tabBar.viewControllers?.count == 3 ){

                    //create tab profile
                    let profileTab = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigator")
                    let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "account"), selectedImage: UIImage(named: "account"))
                    profileTab?.tabBarItem = profileTabBarItem
                
                    //create my course tab
                    let courseTab = self.storyboard?.instantiateViewController(withIdentifier: "MyCourseNavigator")
                    let courseTabBarItem = UITabBarItem(title: "My Csourses", image: UIImage(named: "mycourse"), selectedImage: UIImage(named: "mycourse"))
                    courseTab?.tabBarItem = courseTabBarItem
                
                
                    tabBar.viewControllers?.removeLast() //remove login tab
                    tabBar.viewControllers?.append(courseTab!)
                    tabBar.viewControllers?.append(profileTab!)
                
            }
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
        return 300
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.row == 1 && helloWorldTimer == nil){
//            helloWorldTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
//        }
//    }
    


    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentRow = indexPath.row
//        if indexPath.row == 0{
//           let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_head_list" , for: indexPath) as! HomeHeaderTableViewCell
//            
//            cell.MyCollecttionView.reloadData()
//            
//            cell.textLabel?.numberOfLines = 0
//            
//            
//            let itemWidth =  view.frame.width
//            let itemHeight = cell.MyCollecttionView.frame.height
//            let layout = UICollectionViewFlowLayout()
//            
//            layout.itemSize = CGSize(width:itemWidth, height:itemHeight)
//            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 0
//            cell.MyCollecttionView.collectionViewLayout = layout
//            headerCell = cell
//            
//            return cell
//        }else{

           let cell = self.homeTable.dequeueReusableCell(withIdentifier: "table_list" , for: indexPath) as! CourseListsTableViewCell
            cell.MyCollecttionView.reloadData()
            
            var label : String?
            
            label = detail[indexPath.row];
            cell.header_btn.setTitle(label, for: .normal)
            cell.textLabel?.numberOfLines = 0
            return cell
//        }
        
        
        
        
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
        
        
        if(currentRow == 0){
            courseSaparator = courses["new"]!
        }else{
            courseSaparator = courses["top"]!
        }
        
        collectionView.restorationIdentifier = "\(currentRow)"
        return courseSaparator.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if(indexPath.item == 1 && helloWorldTimer == nil){
//            helloWorldTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
//        }
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = collectionView.restorationIdentifier
        if(identifier != "\(currentRow)"){
            currentRow = Int(identifier!)!
            if(currentRow == 0){
                courseSaparator = courses["new"]!
            }else{
                courseSaparator = courses["top"]!
            }
        }
        
        let thisCourse = courseSaparator[indexPath.row]
        
        var thisCourseImg = self.imgList[thisCourse.id]
        var thisOwnerImg = self.ownerImgList[thisCourse.id]
        
        if(true){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course_list", for: indexPath) as! CourseListsCollectionViewCell
            
            if(thisCourseImg == nil){
                

                
                Course.fetchImgByURL(picUrl: thisCourse.imgPath, completion: { (myImage) in
                    if(myImage == nil){
                        self.imgList[thisCourse.id] = UIImage(named: "download")
                    }else{
                        self.imgList[thisCourse.id] = myImage
                        DispatchQueue.main.async {
                            cell.img_btn.setBackgroundImage(myImage, for: .normal)
                        }
                    }

                })
                thisCourseImg = UIImage(named: "loading")
//                self.imgList[thisCourse.id] = thisCourseImg
            }
            
            if(thisOwnerImg == nil){
                
                if(!thisCourse.ownerImgPath.contains("http")){
                    thisCourse.ownerImgPath = "\(Network.IP_Address_Master)/"+thisCourse.ownerImgPath
                }
                
                Course.fetchImgByURL(picUrl: thisCourse.ownerImgPath, completion: { (myImage) in
                    if(myImage != nil){
                        self.ownerImgList[thisCourse.id] = myImage
                        DispatchQueue.main.async {
                            cell.intstructor_img.image = myImage
                        }
                    }

                })
                thisOwnerImg = UIImage(named: "user")
                self.ownerImgList[thisCourse.id] = thisOwnerImg
            }
            
            cell.initCell(img: thisCourseImg!, name: thisCourse.name , id : thisCourse.id)
            cell.course_rating.settings.updateOnTouch = false
            cell.course_rating.settings.fillMode = .precise
            let rateText = "\(thisCourse.rating) from \(thisCourse.rateCount) vote"
            cell.course_rating.text = thisCourse.rateCount > 1 ? "\(rateText)s" : rateText
            cell.course_rating.rating = thisCourse.rating
            cell.instructor_name.text = thisCourse.owner
            cell.intstructor_img.image = thisOwnerImg
//            cell.intstructor_img
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course_list", for: indexPath) as! CourseListsCollectionViewCell
            
            if(thisCourseImg == nil){
                Course.fetchImgByURL(picUrl: thisCourse.imgPath, completion: { (myImage) in
                    if(myImage == nil){
                        self.imgList[thisCourse.id] = UIImage(named: "download")
                    }else{
                        self.imgList[thisCourse.id] = myImage
                        DispatchQueue.main.async {
                            cell.img_btn.setBackgroundImage(myImage, for: .normal)
                        }
                    }
                })
                thisCourseImg = UIImage(named: "loading")
                self.imgList[thisCourse.id] = thisCourseImg
            }
            
            if(thisOwnerImg == nil){
                Course.fetchImgByURL(picUrl: thisCourse.ownerImgPath, completion: { (myImage) in
                    self.ownerImgList[thisCourse.id] = myImage
                    DispatchQueue.main.async {
                        cell.intstructor_img.image = myImage
                    }
                })
                thisOwnerImg = UIImage(named: "user")
                 self.ownerImgList[thisCourse.id] = thisOwnerImg
            }
            
            cell.initCell(img: thisCourseImg!, name: thisCourse.name , id : thisCourse.id)
            cell.course_rating.settings.updateOnTouch = false
            cell.course_rating.settings.fillMode = .precise
            let rateText = "\(thisCourse.rating) from \(thisCourse.rateCount) vote"
            cell.course_rating.text = thisCourse.rateCount > 1 ? "\(rateText)s" : rateText
            cell.course_rating.rating = thisCourse.rating
            cell.instructor_name.text = thisCourse.owner
            cell.intstructor_img.image = thisOwnerImg

            return cell
        }

        
            
        
    }
    
    
    
}

