//
//  ReplyCommentViewController.swift
//  L2D
//
//  Created by Magnus on 4/30/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class ReplyCommentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
 
    var commentMsg : String = ""
    var commentName : String = ""
    var commentDateTimeString : String = ""
    var parentId : Int = 0
    var courseId : Int = 0
    
    var subCommentData : [Comment] = []
    
    @IBOutlet weak var ReplyCommentTable: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var BottomView: UIView!
    
//    var offsetY:CGFloat = 0
//    @objc func keyboardFrameChangeNotification(notification: Notification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
//            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
//            let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIViewAnimationOptions.curveEaseInOut.rawValue)
//            let animationCurve = UIViewAnimationOptions(rawValue: UInt(animationCurveRawValue))
//            if let _ = endFrame, endFrame!.intersects(self.BottomView.frame) {
//                self.offsetY = self.BottomView.frame.maxY - endFrame!.minY
//                UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
//                    self.BottomView.frame.origin.y = self.BottomView.frame.origin.y - self.offsetY
//
//                    //                    self.offsetY = self.BottomView.frame.maxY - endFrame!.minY
//                    self.ReplyCommentTable.frame.origin.y = self.ReplyCommentTable.frame.origin.y - self.offsetY
//
//                    if(self.subCommentData.count > 0){
//                        // -1 from max count to get index
//                        // +1 from main comment
//                        let indexPath = NSIndexPath(row: self.subCommentData.count - 1 + 1, section: 0)
//                        self.ReplyCommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
//                    }
//
//                }, completion: nil)
//                //                self.view.layoutIfNeeded()
//            } else {
//                if self.offsetY != 0 {
//                    UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
//                        self.BottomView.frame.origin.y = self.BottomView.frame.origin.y + self.offsetY
//
//                        self.ReplyCommentTable.frame.origin.y = self.ReplyCommentTable.frame.origin.y + self.offsetY
//
//                        if(self.subCommentData.count > 0){
//                            // -1 from max count to get index
//                            // +1 from main comment
//                            let indexPath = NSIndexPath(row: self.subCommentData.count - 1 + 1, section: 0)
//                            self.ReplyCommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
//                        }
//
//                        self.offsetY = 0
//                    }, completion: nil)
//                    //                    self.view.layoutIfNeeded()
//                }
//
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ReplyCommentTable.reloadData()
        DispatchQueue.main.async(execute: {
            
            if(self.subCommentData.count > 0){
                // -1 from max count to get index
                // +1 from main comment
                let indexPath = NSIndexPath(row: self.subCommentData.count - 1 + 1, section: 0)
                self.ReplyCommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
            }
            
        })
        
        
        textField.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
//        view.addGestureRecognizer(tap)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameChangeNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(AppDelegate.hasLogin){
            self.BottomView.isHidden = false
        }else{
            self.BottomView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField.text != nil && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            textField.allowsEditingTextAttributes = false
            Comment.sendComment(courseId: self.courseId, memberId: (AppDelegate.userData?.idmember)!, message: textField.text!, parentId: self.parentId) { (result) in
                self.subCommentData.append(result!)
                self.ReplyCommentTable.reloadData()
                DispatchQueue.main.async(execute: {
                    
                    if(self.subCommentData.count > 0){
                        // -1 from max count to get index
                        // +1 from main comment
                        let indexPath = NSIndexPath(row: self.subCommentData.count - 1 + 1, section: 0)
                        self.ReplyCommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
                    }
                    
                })
                
                textField.text?.removeAll()
                textField.allowsEditingTextAttributes = true
            }
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( 1 + subCommentData.count )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainComment", for: indexPath) as! ReplyMainCommentTableViewCell
            
            cell.msgLabel.text = commentMsg
            cell.nameLabel.text = commentName
            cell.dateTimeLabel.text = commentDateTimeString
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.timeStyle = DateFormatter.Style.medium
//            dateFormatter.dateStyle = DateFormatter.Style.medium
            //        dateFormatter.timeZone = NSTimeZone() as TimeZone!
//            cell.dateTimeLabel.text = dateFormatter.string(from: (a_comment.dateTime))
            
            cell.selectionStyle = .none
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubComment", for: indexPath) as! ReplySubCommentTableViewCell
            
            // -1 from main comment
            let a_comment = subCommentData[indexPath.row - 1]
            
            cell.msgLabel.text = a_comment.message
            cell.nameLabel.text = a_comment.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium
            dateFormatter.dateStyle = DateFormatter.Style.medium
            //        dateFormatter.timeZone = NSTimeZone() as TimeZone!
            cell.dateTimeLabel.text = dateFormatter.string(from: (a_comment.dateTime))
            
            cell.selectionStyle = .none
            
            return cell
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
