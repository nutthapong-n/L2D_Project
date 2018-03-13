//
//  CourseContentViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/26/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import AAPlayer
import Cosmos

class CourseContentViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource, AAPlayerDelegate {

    
    
    
    var courseId : Int?
    var course : Course?
    var isRegis : Bool = false
    var showCourse : [CourseForShow_Model] = []
    var rating : Double?
    
    @IBOutlet weak var tableviewTopConst : NSLayoutConstraint!
    @IBOutlet weak var table : CoursePreviewTable!
    @IBOutlet weak var player: AAPlayer!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var player_buttom_const: NSLayoutConstraint!
    
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
//            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(dismissBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func actualizarDators(_ refreshControl : UIRefreshControl){
        
        let table_header = table.dequeueReusableCell(withIdentifier: "sectionHeader", for: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
        let enroll_btn = table_header.enroll_btn
        
        Course.getCoureWithCheckRegis(id: courseId!) { (result, msg, isRegis, rating) in
            if(msg != nil){
                self.myAlert(title: "Error", text: msg!)
            }
            else{
                self.course = result
                self.showCourse = []
                
                if(rating != nil){
                    self.rating = rating
                }else{
                    self.rating = 0.0
                }
                
                if(isRegis)!{
                    enroll_btn?.setTitle("enrolled", for: .normal)
                    enroll_btn?.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
                }
                for section in (result?.section!)!{
                    self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0, fileKey: ""))
                }
//                self.player.displayView.titleLabel.text = self.course?.name
                self.table.reloadData()
            }
            
            refreshControl.endRefreshing()
        }

    }
    

    
    override func loadView() {
        super.loadView()        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0 || section == 2){
            return nil
        }else{
            return "Contents"
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
            return self.showCourse.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 50
        }else if(indexPath.section == 2){
            return 40
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = self.table.dequeueReusableCell(withIdentifier: "sectionHeader", for: indexPath) as! CourseSectionHeaderTableViewCell
            
            cell.ratingBar.didFinishTouchingCosmos = { rating in
                Course.rateCourse(CourseId: self.courseId!, memberId: (AppDelegate.userData?.idmember)!, rating: cell.ratingBar.rating){
                    (result) in
                    if(result){
                        self.myAlert(title: "Success", text: "you rated this course with \(cell.ratingBar.rating) points.")
                    }else{
                        self.myAlert(title: "Rating error", text: "")
                    }
                    
                }
            }
            if(isRegis){
                cell.enroll_btn.setTitle("enrolled", for: .normal)
                cell.enroll_btn.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
                
                cell.ratingBar.rating = rating!
                cell.ratingBar.isHidden = false
            }
            else{
                cell.ratingBar.isHidden = true
            }
            cell.titleLabel.text = course?.name
            return cell
        }else{//is a section and sub section
            let sectionLocal = self.showCourse
            if(sectionLocal[indexPath.row].type == 0){//if is section
                let section = self.showCourse[indexPath.row]
                let cell = self.table.dequeueReusableCell(withIdentifier: "section", for: indexPath) as! CourseSectionTableViewCell
                cell.section_id = section.id
                cell.sec_label.text = section.name
                
                return cell
            }else{ // if is subsection
                let sub_section = self.showCourse[indexPath.row]
                let cell = self.table.dequeueReusableCell(withIdentifier: "sub_section", for: indexPath) as! CourseSubsectionTableViewCell
                cell.Subsection_id = sub_section.id
                cell.name = sub_section.name
                cell.name_label.text = sub_section.name
                cell.fileKey = sub_section.fileKey
                
                return cell
            }

            
        }
    }
    
    func closeAllExpand(){
        for sec in self.showCourse{
            let elemIndex = self.showCourse.index(of: sec)
            if(sec.type == 1){
                self.showCourse.remove(at: elemIndex!)
                table.beginUpdates()
                let myindexPath = IndexPath(row: elemIndex!, section: 1)
                table.deleteRows(at: [myindexPath], with: .top)
                table.endUpdates()
            }else{
                let myIndexPath = IndexPath(row: elemIndex!, section: 1)
                let cell = table.cellForRow(at: myIndexPath) as! CourseSectionTableViewCell
                cell.expandsion = false
                cell.expand_img.isHighlighted = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //isHeader
        if(indexPath.section == 0){
        
        }else{
            if(self.showCourse[indexPath.row].type == 0){
                let cell = tableView.cellForRow(at: indexPath) as! CourseSectionTableViewCell
                if(!cell.expandsion){
                    closeAllExpand()
                    for sec in (course?.section)!{
                        if(sec.id == cell.section_id){
                            var index = course?.section?.index(of: sec)
                            index = index! - 1
                            if var myCounter = index{
                                for sub in sec.subSection!{
                                    myCounter += 1
                                    self.showCourse.insert(CourseForShow_Model(name: sub.name , id: sub.id, type: 1, fileKey: sub.fileKEY), at: myCounter)
                                    //                    self.showCourse.append(CourseForShow_Model(name: sub.name , id: sub.id, type: 1))
                                    table.beginUpdates()
                                    let myindexPath = IndexPath(row: myCounter, section: 1)
                                    table.insertRows(at: [myindexPath] ,with: .top)
                                    table.endUpdates()
                                }
                                cell.expand_img.isHighlighted = true
                                cell.expandsion = true
                                break
                            }
                        }
                    }
                }else{
                    closeAllExpand()
                }
            }else{//is sub section
                let cell = tableView.cellForRow(at: indexPath) as! CourseSubsectionTableViewCell
                Course.getfile(key: cell.fileKey!, completion: { (path, error) in
                    let url = "http://158.108.207.7:8080/\(path ?? "")"
                    self.player.playVideo(url)
                    self.player.startPlayback()
                })
                
                
            }

        }
    }
    @IBAction func enroll(_ sender: UIButton) {
        if(isRegis){
            course?.UnRegister(completion: { (result) in
                if(result){
                    sender.setTitle("Enroll now!", for: .normal)
                    sender.backgroundColor = UIColor(red:98, green:210, blue:75, alpha:1.0)
                    
                    let table_header = self.table.dequeueReusableCell(withIdentifier: "sectionHeader", for: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
                    
                    let ratingBar = table_header.ratingBar
                    ratingBar?.rating = 0.0
                    ratingBar?.isHidden = true
                    self.isRegis = false
                }else{
                    self.myAlert(title: "", text: "can not unenroll")
                }
            })
        }else{
            course?.Register(completion: { (result) in
                if(result){
                    sender.setTitle("enrolled", for: .normal)
                    sender.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
                    
                    let table_header = self.table.dequeueReusableCell(withIdentifier: "sectionHeader", for: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
                    
                    let ratingBar = table_header.ratingBar
                    ratingBar?.rating = 0.0
                    ratingBar?.isHidden = false
                    self.isRegis = true
                }else{
                    let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    loginController.backRequest = true
                    self.navigationController?.pushViewController(loginController, animated: true)
                }
            })
        }

    }
    @IBAction func close_page(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("was touch")
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.addSubview(self.refreshControl)

        
        Course.getCoureWithCheckRegis(id: courseId!) { (result, msg, isRegis, rating) in
            if(msg != nil){
                self.myAlert(title: "Error", text: msg!)
            }
            else{
                self.course = result
                
                if(rating != nil){
                    self.rating = rating
                }else{
                    self.rating = 0.0
                }
                
                if(isRegis)!{
                    self.isRegis = isRegis!
                    
                }
                for section in (result?.section!)!{
                    if(section.rank != 0){
                        self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0, fileKey: "" ))
                    }
                    
                }
//                self.player.displayView.titleLabel.text = self.course?.name
                
                self.table.reloadData()
            }
            
        }
        
        
        



        
        AppDelegate.restrictRotation = false;
//        let url = URL(string: "http://lxdqncdn.miaopai.com/stream/6IqHc-OnSMBIt-LQjPJjmA__.mp4?ssig=a81b90fdeca58e8ea15c892a49bce53f&time_stamp=1508166491488")!
        
//        let url = URL(string: "http://158.108.207.7:8080/api/ts/key999/25/30/index.m3u8")!
        
        player.delegate = self
        player.playVideo("http://158.108.207.7:8080/api/ts/key999/25/30/index.m3u8")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.04, green:0.04, blue:0.03, alpha:0.3)
        let viewHeight = self.view.frame.height
        tableviewTopConst.constant = 1/3*viewHeight
        let navHeight = self.navigationController?.navigationBar.frame.height
        player_buttom_const.constant = 2/3*viewHeight - (navHeight)!
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pausePlayback()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.28, blue:0.28, alpha:1.0)
//        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.28, blue:0.28, alpha:1.0)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
    }
    
    @objc func deviceRotated(){
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            player_buttom_const.constant = 0
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            // Resize other things
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            let viewHeight = self.view.frame.height
            let navHeight = self.navigationController?.navigationBar.frame.height
            player_buttom_const.constant = 2/3*viewHeight - (navHeight)!
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate.restrictRotation = true;
        
    }
    
    @objc func DismissPage(){
        self.dismiss(animated: true, completion: nil)
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

