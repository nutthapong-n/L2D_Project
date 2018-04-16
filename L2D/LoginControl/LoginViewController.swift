//
//  LoginViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class LoginViewController: BaseViewController {
    @IBOutlet weak var login_button: UIButton!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var backRequest : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login_button.layer.cornerRadius = 5
        
    
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DisMissKeyboardForUserName(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func DisMissKeyboardForPassWord(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func goLogin(_ sender: Any) {
        
//        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController
//        self.navigationController?.present(profileViewController, animated: true, completion: nil)
//        self.dismiss(animated: false, completion: nil)

        
//        print("GO LOGIN")

        
    }
    
    func myAlert(text : String){
        self.resignFirstResponder()
        let alert = UIAlertController(title:"Fail!",message: text, preferredStyle: .alert)
        
        let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        
        alert.addAction(dismissBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSeque"{
            if let uName = username.text, let pass = password.text{
                let mySqe = segue as! LoginSeque
                
                User_model.logIn(username: uName, password: pass, completion: { (status, code) in
                    if(status){
                        AppDelegate.hasLogin = true
                        if(self.backRequest != nil){
                            AppDelegate.reLoadRequest = true
                            let viewColtrollers = self.navigationController?.viewControllers
                            let lenght = viewColtrollers?.count
                            let preView = viewColtrollers![lenght! - 2] as! CourseContentViewController
                            preView.videoRestrict = true
                            
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            mySqe.login_success = true
                            mySqe.perform()
                        }
                        
                    }else{
                        if(code == 0){
                            mySqe.login_success = false
                            self.myAlert(text : "user or password incorrect")
                        }else if(code == 1){
                            self.myAlert(text : "ERROR CODE : 500 (sever error)")
                        }
                    }
                })
                
            }
        }else if( segue.identifier == "regisSegue"){
            let des = segue.destination as! RegisterViewController
            
            if(backRequest != nil && backRequest!){
                des.backRequest = true
            }else{
                des.backRequest = false
            }
            
        }
    }
    

}
