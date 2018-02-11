//
//  ProfileUpdatePasswordViewController.swift
//  L2D
//
//  Created by Magnus on 2/11/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileUpdatePasswordViewController: UIViewController {

    @IBOutlet weak var oldPsswd: UITextField!
    @IBOutlet weak var newPsswd: UITextField!
    @IBOutlet weak var retypeNewPsswd: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmUpdateClicked(_ sender: Any) {
        if(newPsswd.text == retypeNewPsswd.text){
            //Do change psswd
            let parameters: Parameters = [
                "idmember" : AppDelegate.userData?.idmember ?? "",
                "oldPasswd" : oldPsswd.text ?? "",
                "passwd" : newPsswd.text ?? ""
            ]
            
            Alamofire.request(Network.IP_Address_Master+"/member/update",method : .put, parameters : parameters , encoding: JSONEncoding.default)
                .responseJSON{
                    
                    response in switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        self.myAlert(title: json["status"] == true ? "Success!" : "Failed!", text: json["message"].stringValue)
                    case .failure(let error):
                        self.myAlert(title: "Failed!", text: error as! String)
                    }

        }
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
}
