//
//  CourseContentViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/26/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Cosmos
import SafariServices
import GradientProgressBar
import AVKit

class CourseContentViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource{

    
    
    
    var courseId : Int?
    var course : Course?
    var isRegis : Bool = false
    var showCourse : [CourseForShow_Model] = []
    var sectionIndexing : [Int] = []
    var userRating : Double?
    var currentSection : Int?
    var videoRestrict : Bool = false
    var player : AVPlayer?
    var onShow : Bool = true
    var timeCounter = 0
    var isPlaying = true
    var isShowDoc = false
    var webViewTonConst: NSLayoutConstraint?
    @IBOutlet weak var maxTime: UILabel!
    
    @IBOutlet weak var toggleStageBtn: UIButton!
    @IBOutlet weak var videoFuncView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tableviewTopConst : NSLayoutConstraint!
    @IBOutlet weak var table : CoursePreviewTable!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var toggleScreenBtn: UIButton!
    @IBOutlet weak var videoWaiter: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
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
    
    func setupPlayer( url : URL){

        self.player = AVPlayer(url: url)
        slider.value = 0.0
        timeCounter = 0
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 1/3*viewHeight)
        self.playerView.layer.insertSublayer(playerLayer, at: 0)
        
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (time) in
            
            let second = time.seconds
            let curSecond = String(format: "%02d", Int((second)) % 60)
            let curMinute = String(format: "%02d", Int((second) / 60))
            self.currentTime.text = "\(curMinute):\(curSecond)"
            self.slider.value = Float(second)
            self.isPlaying = true
            self.stopWaiter()
            
            if(self.isPlaying && self.timeCounter <= 10){
                self.timeCounter = self.timeCounter + 1
                if(self.timeCounter == 10 && self.onShow){
                    self.toggleGUI()
                }
            }
        }
        self.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = self.player?.currentItem?.duration {
                slider.maximumValue = Float(duration.seconds)
                let maxSecond = String(format: "%02d", Int((duration.seconds)) % 60)
                let maxMinute = String(format: "%02d", Int((duration.seconds) / 60))
                maxTime.text = "\(maxMinute):\(maxSecond)"
                

            }
        }

    }
    
    @objc func sliderChange(){

        let seekTime = slider.value
        let toTime = CMTime(value: CMTimeValue(seekTime), timescale: 1)
        player?.seek(to: toTime)
        play()
    }
        
    
    func play(){
        self.player?.play()
        self.toggleStageBtn.setImage(UIImage(named: "pause_gray"), for: .normal)
        startWaiter()
        
    }
    
    func startWaiter(){
        self.toggleStageBtn.isHidden = true
        self.videoWaiter.isHidden = false
        self.videoWaiter.startAnimating()
        self.timeCounter = 0
    }
    
    func stopWaiter(){
        self.toggleStageBtn.isHidden = false
        self.videoWaiter.stopAnimating()
        self.videoWaiter.isHidden = true
        
    }
    
    func pause(){
        self.player?.pause()
        self.toggleStageBtn.setImage(UIImage(named: "play_gray"), for: .normal)
        isPlaying = false
    }
    
    @IBAction func toggleStage(_ sender: Any) {
        let button = sender as! UIButton
        if(button.currentImage == UIImage(named: "play_gray")){
            button.setImage(UIImage(named: "pause_gray"), for: .normal)
            self.play()
        }else{
            button.setImage(UIImage(named: "play_gray"), for: .normal)
            self.pause()
        }
    }
    
    @IBAction func toggleFullscreen(_ sender: Any) {
        let button = sender as! UIButton
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            button.setImage(UIImage(named: "full_screen"), for: .normal)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }else if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            button.setImage(UIImage(named: "normal_screen"), for: .normal)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    
    }
    
    @IBAction func go_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if(touch?.view == self.playerView){
            toggleGUI()
        }
    }
    
    func clearVideo(){
        self.pause()
        self.playerView.layer.sublayers![0].removeFromSuperlayer()
    }
    
    func toggleGUI(){
        if(onShow){
            
            UIView.animate(withDuration: 0.5, animations: {
                self.videoFuncView.alpha = 0
                self.toggleStageBtn.alpha = 0
                self.backBtn.alpha = 0
                self.videoTitle.alpha = 0
                
            })

            onShow = false
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.videoFuncView.alpha = 1
                self.toggleStageBtn.alpha = 1
                self.backBtn.alpha = 1
                self.videoTitle.alpha = 1
            })
            timeCounter = 0
            onShow = true
        }
    }
    
    
    @objc func actualizarDators(_ refreshControl : UIRefreshControl){
        
        let table_header = table.dequeueReusableCell(withIdentifier: "sectionHeader", for: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
        let enroll_btn = table_header.enroll_btn
        
        Course.getCoureWithCheckRegis(id: courseId!) { (result, msg, isRegis, userRating) in
            if(msg != nil){
                self.myAlert(title: "Error", text: msg!)
            }
            else{
                for sec in (result?.section!)!{
                    if(sec.rank == 0){
                        let index = result?.section?.index(of: sec)
                        result?.section?.remove(at: index!)
                    }
                }
                
                self.course = result
                self.showCourse.removeAll()
                self.sectionIndexing.removeAll()
                if(userRating != nil){
                    self.userRating = userRating
                }else{
                    self.userRating = 0.0
                }
                
                if(isRegis)!{
                    enroll_btn?.setTitle("Unenrolled", for: .normal)
                    enroll_btn?.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
//                    table_header.progressBar.isHidden = false
                }else{
//                    table_header.progressBar.isHidden = true
                }

                for section in (result?.section!)!{
                    if(section.rank != 0){
                        self.sectionIndexing.append(section.id)
                        self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0, fileKey: "", fileType : .none ))
                    }
                    
                    for sub in section.subSection!{
                        self.sectionIndexing.append(sub.id)
                    }
                    
                }

                self.table.reloadData()
            }
            
            refreshControl.endRefreshing()
        }

    }
    

    
    override func loadView() {
        super.loadView()
        setWebView()

    }
    
    func setWebView(){
        let frame = self.view.frame
        
        let web_lead = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        let web_tail = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        let web_bottom = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        let web_top = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: frame.height)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.webViewTonConst = web_top
        view.addConstraints([web_top,web_lead,web_tail,web_bottom])
        
        
//        let bar = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        let bar = UIView()
        bar.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        //create close btn
        let closebutton = UIButton()
        closebutton.setImage(UIImage(named: "expand_arrow"), for: .normal)
        closebutton.addTarget(self, action: #selector(hideWebView), for: UIControlEvents.touchUpInside)
        
        
        let cb_tail = NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: closebutton, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 10)
        let cb_top = NSLayoutConstraint(item: closebutton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: bar, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10)
        let cb_width = NSLayoutConstraint(item: closebutton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 30)
        let cb_height = NSLayoutConstraint(item: closebutton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 30)
        
        closebutton.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(closebutton)
        bar.addConstraints([cb_top,cb_tail,cb_width,cb_height])
        
        
//        create expandBtn
        let expandbutton = UIButton()
        expandbutton.setImage(UIImage(named: "collapse_arrow"), for: .normal)
        expandbutton.addTarget(self, action: #selector(exPandWebView), for: UIControlEvents.touchUpInside)
        expandbutton.translatesAutoresizingMaskIntoConstraints = false

        let eb_tail = NSLayoutConstraint(item: closebutton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: expandbutton, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 10)
        let eb_top = NSLayoutConstraint(item: expandbutton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: bar, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10)
        let eb_width = NSLayoutConstraint(item: expandbutton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 30)
        let eb_height = NSLayoutConstraint(item: expandbutton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 30)


        bar.addSubview(expandbutton)
        bar.addConstraints([eb_top,eb_tail,eb_width,eb_height])
        
        self.webView.addSubview(bar)


        let bar_top = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: bar, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
        let bar_height = NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 50)
        let bar_leading = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: bar, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        let bar_tailing = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: bar, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addConstraints([bar_top,bar_height,bar_leading,bar_tailing])
    }
    
    @objc func exPandWebView(){
        self.webViewTonConst?.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func hideWebView(){
        isShowDoc = false
        let viewFrame = self.view.frame
        self.webViewTonConst?.constant = viewFrame.height
        UIView.animate(withDuration: 0.5, animations: {
//            self.webView.isHidden = true
            self.view.layoutIfNeeded()
        })
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
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = self.table.dequeueReusableCell(withIdentifier: "sectionHeader", for: indexPath) as! CourseSectionHeaderTableViewCell
            
            if(isRegis){
                cell.enroll_btn.setTitle("Unenrolled", for: .normal)
                cell.enroll_btn.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
                self.table.allowsSelection = true
                cell.rate_btn.isHidden = false
                cell.progressBar.isHidden = false
            }else{
                cell.rate_btn.isHidden = true
                self.table.allowsSelection = false
                cell.progressBar.isHidden = true
            }
            
            cell.ratingBar.settings.fillMode = .precise
            cell.ratingBar.settings.updateOnTouch = false
            if(self.course != nil){
                let rateText = "\(self.course?.rating ?? 0.0) from \(self.course?.rateCount ?? 0) vote"
                if let rateCount = self.course?.rateCount {
                    cell.ratingBar.text = rateCount > 1 ? "\(rateText)s" : rateText
                }
                cell.ratingBar.rating = (self.course?.rating)!
                cell.progressBar.setProgress((self.course?.percentProgress)!/100, animated: true)
            }

            cell.titleLabel.text = self.course?.name
            self.videoTitle.text = self.course?.name

            
            return cell
        }else{//is a section and sub section
            let sectionLocal = self.showCourse
            if(sectionLocal[indexPath.row].type == 0){//if is section
                let section = self.showCourse[indexPath.row]
                let cell = self.table.dequeueReusableCell(withIdentifier: "section", for: indexPath) as! CourseSectionTableViewCell
                cell.section_id = section.id
                cell.sec_label.text = section.name
                

                if(!isRegis){
                    cell.sec_label.textColor = UIColor.lightGray
                }else{
                    cell.sec_label.textColor = UIColor.black
                }
                
                return cell
            }else{ // if is subsection
                let sub_section = self.showCourse[indexPath.row]
                let cell = self.table.dequeueReusableCell(withIdentifier: "sub_section", for: indexPath) as! CourseSubsectionTableViewCell
                
                cell.Subsection_id = sub_section.id
                cell.name = sub_section.name
                cell.name_label.text = sub_section.name
                cell.fileKey = sub_section.fileKey
                cell.fileType = sub_section.filetype
                
                if(!isRegis){
                    cell.name_label.textColor = UIColor.lightGray
                }else{
                    cell.name_label.textColor = UIColor.black
                }
                
                
                if let index = self.sectionIndexing.index(of: cell.Subsection_id!), let curIndex = self.sectionIndexing.index(of: self.currentSection!){
                    if( index  <=  curIndex){
                        cell.name_label.textColor = UIColor.lightGray
                        if(cell.fileType == fileType.document){
                            cell.icon.image = UIImage(named: "pdf_disable")
                        }else if(cell.fileType == fileType.video){
                            cell.icon.image = UIImage(named: "play_button_disable")
                        }else{
                            
                        }
                    }else{
                        if(cell.fileType == fileType.document){
                            cell.icon.image = UIImage(named: "pdf_enable")
                        }else if(cell.fileType == fileType.video){
                            cell.icon.image = UIImage(named: "play_button")
                        }else{
                            
                        }
                        
                    }
                }else{
                    if(cell.fileType == fileType.document){
                        cell.icon.image = UIImage(named: "pdf_enable")
                    }else if(cell.fileType == fileType.video){
                        cell.icon.image = UIImage(named: "play_button")
                    }else{
                        
                    }
                }
                return cell
            }

            
        }
    }
    
    func closeAllExpand(){
        //for visible cell
        let cells = self.table.visibleCells
        for cell in cells{
            let subPath = self.table.indexPath(for: cell)
            if(cell.classForCoder == CourseSubsectionTableViewCell.self){
                self.showCourse.remove(at: (subPath?.row)!)
                table.beginUpdates()
                table.deleteRows(at: [subPath!], with: .top)
                table.endUpdates()
            }else if(cell.classForCoder == CourseSectionTableViewCell.self){
                let cell = table.cellForRow(at: subPath!) as! CourseSectionTableViewCell
                cell.expandsion = false
                cell.expand_img.isHighlighted = false
            }
        }
        
        //for invisible cell
        for sec in self.showCourse{
            let elemIndex = self.showCourse.index(of: sec)
            let myIndexPath = IndexPath(row: elemIndex!, section: 1)
            if(sec.type == 1){
                self.showCourse.remove(at: elemIndex!)
                table.deleteRows(at: [myIndexPath], with: .none)
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
                            let index = course?.section?.index(of: sec)
                            if var myCounter = index{
                                for sub in sec.subSection!{
                                    myCounter += 1
                                    self.showCourse.insert(CourseForShow_Model(name: sub.name , id: sub.id, type: 1, fileKey: sub.fileKEY, fileType : sub.type), at: myCounter)
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
                self.currentSection = cell.Subsection_id
                
                
                Course.getfile(key: cell.fileKey!, completion: { (path, error) in
                    cell.name_label.textColor = UIColor.lightGray
                    if(cell.fileType == .video){
                        let url = path
                        if(url != ""){
                            self.clearVideo()
                          self.setupPlayer(url: URL(string: url!)!)
                        }
                        cell.icon.image = UIImage(named: "play_button_disable")
                    }else if(cell.fileType == .document){
                        cell.icon.image = UIImage(named: "pdf_disable")
                        if let url = URL(string: path!) {
//                            self.pause()
                            let viewFrame = self.view.frame
                            self.isShowDoc = true
                            self.webViewTonConst?.constant = viewFrame.height*1/3
                            UIView.animate(withDuration: 0.5, animations: {
                                self.view.layoutIfNeeded()
                                self.webView.loadRequest(URLRequest(url: url))
                            })
                            
                            

                        }
                    }
                    
                    let cells = tableView.visibleCells
                    if let curIndex = self.sectionIndexing.index(of: self.currentSection!){
                        for preCell in cells{
                            if(preCell.classForCoder == CourseSubsectionTableViewCell.self){
                                let mypreCell = preCell as! CourseSubsectionTableViewCell
                                if let index = self.sectionIndexing.index(of: mypreCell.Subsection_id!){
                                    if(curIndex >= index){
                                        mypreCell.name_label.textColor = UIColor.lightGray
                                        if(mypreCell.fileType == .video){
                                            mypreCell.icon.image = UIImage(named: "play_button_disable")
                                        }else if(mypreCell.fileType == .document){
                                            mypreCell.icon.image = UIImage(named: "pdf_disable")
                                        }
                                    }else{
                                        mypreCell.name_label.textColor = UIColor.black
                                        if(mypreCell.fileType == .video){
                                            mypreCell.icon.image = UIImage(named: "play_button")
                                        }else if(mypreCell.fileType == .document){
                                            mypreCell.icon.image = UIImage(named: "pdf_enable")
                                        }
                                    }
                                }
                            }
                        }
                    }

                    
                    Course.updateProgress(CourseId: self.courseId!, memberId: (AppDelegate.userData?.idmember)!, sectionId: cell.Subsection_id!, completion: {
                        (progressPercent) in
                        let tableHeader = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
                        
                        tableHeader.progressBar.setProgress(progressPercent!/100, animated: true)
                    
                    })
                })
                
                
            }

        }
    }
    @IBAction func enroll(_ sender: UIButton) {
        if(isRegis){
            course?.UnRegister(completion: { (result) in
                if(result){
                    sender.setTitle("Enroll now!", for: .normal)
                    sender.backgroundColor = UIColor(red:0.45, green: 0.988, blue:0.839, alpha:1.0)
                    
                    let table_header = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
                    
//                    let ratingBar = table_header.ratingBar
//                    ratingBar?.rating = 0.0
//                    ratingBar?.isHidden = true
                    
                    self.disableTable()
                    let rate_btn = table_header.rate_btn
                    rate_btn?.isHidden = true
                    
                    
                    self.userRating = 0.0
                    self.isRegis = false
                    table_header.progressBar.isHidden = true
                    self.videoRestrict = true
                    self.viewDidLoad()
                }else{
                    self.myAlert(title: "", text: "can not unenroll")
                }
            })
        }else{
            course?.Register(completion: { (result) in
                if(result){
                    sender.setTitle("Unenrolled", for: .normal)
                    sender.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)

                    
                    let table_header = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell

                    self.currentSection = 0
                    self.enableTable()
                    let rate_btn = table_header.rate_btn
                    rate_btn?.isHidden = false
                    
                    self.isRegis = true
                    table_header.progressBar.isHidden = false
                    self.videoRestrict = true
                    self.viewDidLoad()
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
    
    func enableTable(){
        self.table.allowsSelection = true
        let sectionCellList = self.table.visibleCells
        for cell in sectionCellList{
            if(cell.classForCoder == CourseSectionTableViewCell.self ){
                let myCell = cell as! CourseSectionTableViewCell
                myCell.sec_label.textColor = UIColor.black
            }
        }
    }
    
    func disableTable(){
        closeAllExpand()
        self.table.allowsSelection = false
        let sectionCellList = self.table.visibleCells
        
        for cell in sectionCellList{
            if(cell.classForCoder == CourseSectionTableViewCell.self ){
                let myCell = cell as! CourseSectionTableViewCell
                myCell.sec_label.textColor = UIColor.lightGray
            }
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.addSubview(self.refreshControl)

        
        Course.getCoureWithCheckRegis(id: courseId!) { (result, msg, isRegis, userRating) in
            if(msg != nil){
                self.myAlert(title: "Error", text: msg!)
            }
            else{
                for sec in (result?.section!)!{
                    if(sec.rank == 0){
                        let index = result?.section?.index(of: sec)
                        result?.section?.remove(at: index!)
                    }
                }
                
                if(userRating != nil){
                    self.userRating = userRating
                }else{
                    self.userRating = 0.0
                }
                
                if(isRegis)!{
                    self.isRegis = isRegis!
                    
                }
                
                self.showCourse.removeAll()
                self.sectionIndexing.removeAll()
                for section in (result?.section!)!{
                    if(section.rank != 0){
                        self.sectionIndexing.append(section.id)
                        self.showCourse.append(CourseForShow_Model(name: section.name, id: section.id, type: 0, fileKey: "", fileType : .none ))
                    }
                    
                    for sub in section.subSection!{
                        self.sectionIndexing.append(sub.id)
                    }
                    
                }
                self.course = result
                self.currentSection = result?.currentSection
//                self.player.displayView.titleLabel.text = self.course?.name
                
                self.table.reloadData()
            }
            
        }
        
        
        AppDelegate.restrictRotation = false;
        
        if(!self.videoRestrict){
            self.setupPlayer( url : URL(string : "http://158.108.207.7:8080/api/ts/key999/25/30/index.m3u8")!)
            self.slider.addTarget(self, action: #selector(sliderChange), for: UIControlEvents.valueChanged)
        }else if(self.videoRestrict){
            self.videoRestrict = false
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.04, green:0.04, blue:0.03, alpha:0.3)
        let viewHeight = self.view.frame.height
        tableviewTopConst.constant = 1/3*viewHeight
//        self.webViewTonConst.constant = 0
        player_buttom_const.constant = 2/3*viewHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pause()
        self.navigationController?.setNavigationBarHidden(false , animated: false)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        
//        update progress when view disappear
    }
    
    @objc func deviceRotated(){
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            let viewHeight = self.view.frame.height
            let viewWidth = self.view.frame.width
            
            //set player layout
            self.playerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            let playerLayer = self.playerView.layer.sublayers![0]
            playerLayer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            player_buttom_const.constant = 0
            self.toggleScreenBtn.setImage(UIImage(named: "normal_screen"), for: .normal)
            
            //set webview layout
//            self.webView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            self.webViewTonConst?.constant = 0
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            let viewHeight = self.view.frame.height
            let viewWidth = self.view.frame.width
            
            //set player layout
            self.playerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 1/3*viewHeight)
            let playerLayer = self.playerView.layer.sublayers![0]
            playerLayer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 1/3*viewHeight)
            player_buttom_const.constant = 2/3*viewHeight
            self.toggleScreenBtn.setImage(UIImage(named: "full_screen"), for: .normal)
            
            //set webview layout
//            self.webView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            if(isShowDoc){
                self.webViewTonConst?.constant = viewHeight*1/3
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        AppDelegate.restrictRotation = true;
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true , animated: false)
        if(self.videoRestrict){
            let cell = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! CourseSectionHeaderTableViewCell
            self.enroll(cell.enroll_btn)
        }
    }
    
    @objc func DismissPage(){
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if( segue.destination.restorationIdentifier == "RateCourseID"){
            let dest = segue.destination as! RateCourseViewController
            dest.userRating = self.userRating!
            dest.courseId = self.courseId!
        }
    }
    

}

