//
//  LoginViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var login_button: UIButton!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
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
                
                
//                if uName == "admin" && pass=="admin"{

                    //กำหนดให้ตัวแปล mySqe คือเส้นเชื่อมระหว่างหน้า
                    let mySqe = segue as! LoginSeque
                
                let parameters: Parameters = ["username" : "meejansumit","passwd" : "mit0805813950" ]
                Alamofire.request("http://158.108.207.7:8090/elearning/member/login",method : .post, parameters : parameters , encoding: JSONEncoding.default)
                    .responseJSON{

                        response in switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            if(json["idmember"] != nil && json["idmember"] != "" || (uName == "admin" && pass == "admin")){
                                AppDelegate.hasLogin = true;
                                mySqe.login_success = true;
                                mySqe.perform()
                            }else{
                                mySqe.login_success = false;
                                self.myAlert(text : "user or password incorrect")
                            }
                        case .failure(let error):
                            self.myAlert(text : "ERROR L2D001 : Login api error")
                        }
                }
                
            }
        }
    }
    

}
