//
//  RegisterViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 22/1/2561 BE.
//  Copyright © 2561 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var regis_button: UIButton!
    @IBOutlet weak var name_input: UITextField!
    @IBOutlet weak var surname_input: UITextField!
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var pass_input: UITextField!
    @IBOutlet weak var rePass_input: UITextField!
    @IBOutlet weak var e_mail_input: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "regis_seque"){
            if let name = name_input.text,
                let surname = surname_input.text,
                let username = username_input.text,
                let pass = pass_input.text,
                let rePass = rePass_input.text,
                let email = e_mail_input.text{
                

                if(username == "" || pass == "" || email == ""){
                    self.alert(text: "please enter username , password and e-mail")
                }else if(pass != rePass){
                    self.alert(text: "password doesn't match")
                }else{
                    let parameters: Parameters = [
                        "name" : name,
                        "surname" : surname,
                        "username" : username,
                        "passwd" : pass,
                        "email" : email
                    ]
                    
                    Alamofire.request("http://158.108.207.7:8090/elearning/member/add",method : .post, parameters : parameters , encoding: JSONEncoding.default)
                        .responseJSON{
                            
                            response in switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                let message  = json["message"]
                                if(message != ""){
                                    AppDelegate.hasLogin = true;
                                    let regisSeque = segue as! RegisterSeque
                                    regisSeque.regis_success = true
                                    regisSeque.perform()
                                }else{
                                    self.alert(text: "usrname already exist in system")
                                }
                            case .failure(let error):
                                self.alert(text : "ERROR CODE : 500 (sever error) : \(error)")
                            }
                    }
                }

            }
            
        }
    }
    
    func alert(text : String){
        self.resignFirstResponder()
        let alert = UIAlertController(title:"Fail!",message: text, preferredStyle: .alert)
        
        let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        
        alert.addAction(dismissBtn)
        
        self.present(alert, animated: true, completion: nil)
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
