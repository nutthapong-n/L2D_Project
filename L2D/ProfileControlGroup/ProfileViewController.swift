//
//  ProfileViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/23/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var detail = ["New course" ,"Recommended","In Trend"]
    
//    @IBOutlet weak var homeTable: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var changeUserProfilePicBtn: UIButton!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBAction func DismissKeyboardName(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func DismissKeyboardSurname(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func DismissKeyboardEmail(_ sender: Any) {
        self.resignFirstResponder()
    }
    
 
    
//    var offsetY:CGFloat = 0
//    @objc func keyboardFrameChangeNotification(notification: Notification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
//            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
//            let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIViewAnimationOptions.curveEaseInOut.rawValue)
//            let animationCurve = UIViewAnimationOptions(rawValue: UInt(animationCurveRawValue))
//            if let _ = endFrame, endFrame!.intersects(self.textField.frame) {
//                self.offsetY = self.textField.frame.maxY - endFrame!.minY
//                UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
//                    self.textField.frame.origin.y = self.textField.frame.origin.y - self.offsetY
//                }, completion: nil)
//            } else {
//                if self.offsetY != 0 {
//                    UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
//                        self.textField.frame.origin.y = self.textField.frame.origin.y + self.offsetY
//                        self.offsetY = 0
//                    }, completion: nil)
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameChangeNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
//        view.addGestureRecognizer(tap)
        setProfileInformation()
//        self.view.layoutIfNeeded()
//        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
//        self.imageView.clipsToBounds = true

    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "redirectAfterLogout"){
            AppDelegate.hasLogin = false
            AppDelegate.userData = nil
            AppDelegate.reLoadRequest = nil
        }
        
    }
    
    func myAlert(title : String,text : String){
        self.resignFirstResponder()
        let alert = UIAlertController(title:title,message: text, preferredStyle: .alert)
        
        let dismissBtn = UIAlertAction(title:"Close",style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        
        alert.addAction(dismissBtn)
        
        self.present(alert, animated: true, completion: nil)
    }

//    @IBAction func GoFacebook(_ sender: Any) {
//        UIApplication.shared.open(URL(string:"https://www.facebook.com/nutthapong.nakpipud")!)
//    }
    
    @IBAction func changeUserProfileClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true)
        //        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: nil)
//        print("select image done!")
//        imageView.image = image
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.progressBar.setProgress(0.0, animated: false)
            self.progressBar.isHidden = false
            self.percentageLabel.text = "0%"
            self.percentageLabel.isHidden = false
            self.changeUserProfilePicBtn.isHidden = true
            User_model.uploadPicture(image: image,progressBar: self.progressBar,percentLebel: self.percentageLabel, completion: { (result) in
                if (result) {
                    self.imageView.image = image
                }else{
                    print("upload error")
                    let errAlert = UIAlertController(title: "Error", message: "Uploading failed", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    errAlert.addAction(cancelBtn)
                    self.present(errAlert, animated: true, completion: nil)
                }
                self.progressBar.isHidden = true
                self.changeUserProfilePicBtn.isHidden = false
                self.percentageLabel.isHidden = true
            })
//            self.imageView.image = image
            
        }else{
            print("Error from image picker.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setProfileInformation(){
        nameTextField.text = AppDelegate.userData?.name
        surnameTextField.text = AppDelegate.userData?.surname
        emailTextField.text = AppDelegate.userData?.email
        
        let imgPath = AppDelegate.userData?.photoUrl
        print("img Path : \(imgPath ?? "")")
        Course.fetchImgByURL(picUrl: imgPath!, completion: { (myImage) in
            
            DispatchQueue.main.async {
                self.imageView.image = myImage
            }
        })
//        imageView.image = UIImage()
    }
    @IBAction func updateProfileClicked(_ sender: Any) {
        let parameters: Parameters = [
            "idmember" : AppDelegate.userData?.idmember ?? "",
            "name" : nameTextField.text ?? "",
            "surname" : surnameTextField.text ?? "",
            "email" : emailTextField.text ?? ""
//            "profile" : ""
        ]
        
        Alamofire.request(Network.IP_Address_Master+"/member/update",method : .put, parameters : parameters , encoding: JSONEncoding.default)
            .responseJSON{
                
                response in switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    self.myAlert(title: "Success!", text: "Your profile has been successfully updated!")
                case .failure(let error):
                    self.myAlert(title: "Failed!", text: error as! String)
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

