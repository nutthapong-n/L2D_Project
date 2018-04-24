//
//  CommentTableViewController.swift
//  L2D
//
//  Created by Magnus on 4/23/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController, UITextFieldDelegate {

    
    
    @IBOutlet var CommentTable: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
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
    
    var courseName : String = "Comment" {
        didSet{
//            self.title = "\(courseName) Comment"
            navigationController?.title = "\(courseName) Comment"
        }
    }
    
    var courseId : Int = 0 {
        didSet{
            Comment.getComment(courseId: courseId, completion: {
                (result) in
                
                self.commentData = result!
                
                self.CommentTable.reloadData()
                DispatchQueue.main.async(execute: {
                    let indexPath = NSIndexPath(row: (self.commentData?.count)! - 1, section: 0)
                    self.CommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
                })
            })
        }
    }
    
    var commentData : [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        textField.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameChangeNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(AppDelegate.hasLogin){
            textField.isHidden = false
        }else{
            textField.isHidden = true
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField.text != nil){
            textField.allowsEditingTextAttributes = false
            Comment.sendComment(courseId: self.courseId, memberId: (AppDelegate.userData?.idmember)!, message: textField.text!) { (result) in
                self.commentData?.append(result!)
                self.CommentTable.reloadData()
                DispatchQueue.main.async(execute: {
                    let indexPath = NSIndexPath(row: (self.commentData?.count)! - 1, section: 0)
                    self.CommentTable.scrollToRow(at: indexPath as IndexPath , at: .top, animated: true)
                })
                
                textField.text?.removeAll()
                textField.allowsEditingTextAttributes = true
            }
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = commentData?.count{
            return count
        }
        return 0
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
        
        let a_comment = commentData![indexPath.row]
        
        cell.nameLabel.text = a_comment.name
        
        cell.messageLabel.text = a_comment.message
//        cell.messageLabel.sizeToFit()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeZone = NSTimeZone() as TimeZone!
        cell.dateTimeLabel.text = dateFormatter.string(from: a_comment.dateTime)
        
//        cell.backgroundColor = UIColor.init(hex: "#99d8ff")

//        cell.layer.cornerRadius = 30
        
        if(AppDelegate.hasLogin && AppDelegate.userData?.idmember == a_comment.idMember){
            cell.itemView.backgroundColor = UIColor.init(hex: "#ffd3e4")
        }else{
            cell.itemView.backgroundColor = UIColor.init(hex: "#99D8FF")
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    
}
