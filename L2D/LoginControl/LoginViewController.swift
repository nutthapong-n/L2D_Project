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
        let parameters: Parameters = ["id": 1]

        Alamofire.request("http://192.168.0.104:8080/elearning/member", method: .get, parameters: parameters)
            .responseJSON {
                response in
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
//                    print("firstList is : \(json[0]["cname"].stringValue)")
                    print(response.request)
                }
            



        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSeque"{
            if let uName = username.text, let pass = password.text{
                if uName == "admin" && pass=="admin"{
                    
                    //กำหนดให้ตัวแปล mySqe คือเส้นเชื่อมระหว่างหน้า
                    let mySqe = segue as! LoginSeque
                    mySqe.username = uName //ส่งข้อมูลไปเก็บในตัวแปร username ของอีกหน้า
                    mySqe.password = pass
                    
                    
                    //กำหนดให้ตัวแปล DestinationView คือหน้าวิวปลายทาง
                    let DestinationView = segue.destination as! MainTabViewController
                    //กำหนดค่าให้ตัวแปลของอีกหน้านึง (เหมือนการส่งข้อมูลข้ามหน้า)
                    DestinationView.userID = 1
                    
                }else{
                    //else alert incorrect
                    self.resignFirstResponder()
                    let alert = UIAlertController(title:"Fail!",message:"you username or password incorrect", preferredStyle: .alert)
        
                    let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
                        (alert: UIAlertAction) -> Void in
        
                    })
        
                    alert.addAction(dismissBtn)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    

}
