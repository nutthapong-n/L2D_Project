//
//  CourseContentViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/26/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit

class CourseContentViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource {

    
    
    
    var player = VGPlayer()
    var courseId : Int?
    var course : Course?
    var showCourse : [CourseForShow_Model] = []
    @IBOutlet weak var tableviewTopConst : NSLayoutConstraint!
    @IBOutlet weak var table : CoursePreviewTable!
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(actualizarDators) , for: .valueChanged)
        rc.tintColor = UIColor.black
        return rc
    }()
    
    @objc func actualizarDators(_ refreshControl : UIRefreshControl){
        Course.getCoureById(id: courseId!, completion: { (result) in
            self.course = result
            self.showCourse = []
            for section in result.section!{
                self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0))
            }
            self.player.displayView.titleLabel.text = self.course?.name
            self.table.reloadData()
            refreshControl.endRefreshing()
        })
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
    
    func alert(header : String, text : String){
        self.resignFirstResponder()
        let alert = UIAlertController(title: header, message: text, preferredStyle: .alert)
        
        let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        
        let registerBtn = UIAlertAction(title:"Register",style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            
            let registerController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            registerController.backRequest = true
            self.navigationController?.pushViewController(registerController, animated: true)
        })
        
        alert.addAction(dismissBtn)
        alert.addAction(registerBtn)
        
        
        self.present(alert, animated: true, completion: nil)
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
                            let index = course?.section?.index(of: sec)
                            if var myCounter = index{
                                for sub in sec.subSection!{
                                    myCounter += 1
                                    self.showCourse.insert(CourseForShow_Model(name: sub.name , id: sub.id, type: 1), at: myCounter)
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
            }

        }
    }
    @IBAction func enroll(_ sender: UIButton) {
        course?.Register(completion: { (result) in
            if(result){
                sender.setTitle("enrolled", for: .normal)
                sender.isEnabled = false
                sender.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
            }else{
                self.alert(header : "Fail",text: "Enrollment fail, Please ensure you have register")
                print("enroll error")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.addSubview(self.refreshControl)
        tableviewTopConst.constant = UIScreen.main.bounds.width*3.0/4.0 - 20
        Course.getCoureById(id: courseId!, completion: { (result) in
            self.course = result
            for section in result.section!{
                self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0))
            }
            self.table.reloadData()
            self.player.displayView.titleLabel.text = self.course?.name
        })
        
        AppDelegate.restrictRotation = false;
//        let url = URL(string: "http://lxdqncdn.miaopai.com/stream/6IqHc-OnSMBIt-LQjPJjmA__.mp4?ssig=a81b90fdeca58e8ea15c892a49bce53f&time_stamp=1508166491488")!
        
        let url = URL(string: "http://158.108.207.7:8080/api/ts/key999/25/30/index.m3u8")!
        
        
        self.player.replaceVideo(url)
        view.addSubview(self.player.displayView)
        
        //        self.player.play()
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.view.snp.top)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(3.0/4.0) // you can 9.0/16.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
//        self.player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.player.pause()
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

extension CourseContentViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension CourseContentViewController: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}
