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

class CourseContentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    
    
    var player = VGPlayer()
    var courseId : Int?
    var course : Course?
    @IBOutlet weak var tableviewTopConst : NSLayoutConstraint!
    @IBOutlet weak var table : UITableView!
    
    
    override func loadView() {
        super.loadView()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "mytltle \(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0 || section == 1){
            return 1
        }else{
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        
        if(indexPath.section == 0){
            cell = self.table.dequeueReusableCell(withIdentifier: "sectionHeader", for: indexPath) as! CourseSectionHeaderTableViewCell
        }else if(indexPath.section == 1){
            cell = self.table.dequeueReusableCell(withIdentifier: "section", for: indexPath) as! CourseSectionTableViewCell
            
        }else{
            cell = self.table.dequeueReusableCell(withIdentifier: "sub_section", for: indexPath) as! CourseSubsectionTableViewCell
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.restrictRotation = false;
        let url = URL(string: "http://lxdqncdn.miaopai.com/stream/6IqHc-OnSMBIt-LQjPJjmA__.mp4?ssig=a81b90fdeca58e8ea15c892a49bce53f&time_stamp=1508166491488")!
        
        self.player.replaceVideo(url)
        view.addSubview(self.player.displayView)
        
//        self.player.play()
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.titleLabel.text = "China NO.1"
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.view.snp.top)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(3.0/4.0) // you can 9.0/16.0
        }
        
        tableviewTopConst.constant = UIScreen.main.bounds.width*3.0/4.0
        Course.getCoureById(id: courseId!, completion: { (result) in
            self.course = result
        })
        
       
        
//        let enrollBtn : UIButton = UIButton(frame: CGRect())
//        enrollBtn.setTitle("test", for: .normal)
//        enrollBtn.setTitleColor( UIColor(red:0.15, green:0.00, blue:0.00, alpha:1.0) , for: .normal)
//        enrollBtn.translatesAutoresizingMaskIntoConstraints = false;
//        view.addSubview(enrollBtn)
//
//
//        //left
//        let leftConst = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: enrollBtn, attribute: .trailing, multiplier: 1.0, constant: 100)
//        //right
//
//        //top
//        var topLenght = UIScreen.main.bounds.width*3/4
//        let topConst = NSLayoutConstraint(item: enrollBtn, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: topLenght)
//
//        //bottom
//
//        self.view.addConstraints([leftConst,topConst])
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(DismissPage))
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
