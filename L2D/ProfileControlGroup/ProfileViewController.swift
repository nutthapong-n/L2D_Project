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
    
    var detail = ["New course" ,"Reccommend","In Trend"]
    
//    @IBOutlet weak var homeTable: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextView!
    
    @IBAction func DismissKeyboardName(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func DismissKeyboardSurname(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func DismissKeyboardEmail(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setProfileInformation()

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
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: nil)
        print("select image done!")
        imageView.image = image
    }
    
    func setProfileInformation(){
        nameTextField.text = AppDelegate.userData?.name
        surnameTextField.text = AppDelegate.userData?.surname
        emailTextField.text = AppDelegate.userData?.email
    }
    @IBAction func updateProfileClicked(_ sender: Any) {
        let parameters: Parameters = [
            "idmember" : AppDelegate.userData?.idmember ?? "",
            "name" : nameTextField.text ?? "",
            "surname" : surnameTextField.text ?? "",
            "email" : emailTextField.text ?? "",
            "profile" : ""
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
extension ProfileViewController : UICollectionViewDataSource , UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course_list", for: indexPath) as! ProfileCollectionViewCell
        
        cell.course_img.setBackgroundImage(UIImage(named: "java"), for: .normal)
        
        cell.shadowBox.layer.shadowColor = UIColor.black.cgColor
        cell.shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        cell.shadowBox.layer.shadowOpacity = 0.8
        cell.shadowBox.layer.shadowRadius = 4
        
        return cell
    }
    
}

