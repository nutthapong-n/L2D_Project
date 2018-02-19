//
//  SideMenuTableViewController.swift
//  L2D
//
//  Created by Magnus on 1/30/18.
//  Copyright © 2018 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    var category = [Category]()
    @IBOutlet var categoryTableView: UITableView!
    
    var clickedName:String = ""
    var clickedIndex:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Category.getAllCategory{
            (result) in
            self.category = result
            self.categoryTableView.reloadData()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "GetCourseInCategory"){
//
//            let catSegue = segue as! CategorySegue
//            let navController = catSegue.destination as! UINavigationController
//            let tableViewController = navController.topViewController as! CourseCategoryTableViewController
//            tableViewController.categoryName = clickedName
//            tableViewController.courseIdList = category[clickedIndex].courseIdList!
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    @IBAction func categoryClicked(_ sender: UIButton) {
//        clickedName = sender.currentTitle!
//        clickedIndex = sender.tag
//
//    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryList", for: indexPath) as! SideMenuTableViewCell
        let dataCategory = category[indexPath.row]
        cell.CategoryMenu.text = dataCategory.name
        cell.CourseInCategoryCount.text = "\(dataCategory.courseIdList?.count ?? 0)"
        cell.selectionStyle = .none
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "CourseCategoryTableViewController") as! CourseCategoryTableViewController
        dest.categoryName = self.category[indexPath.row].name
        dest.courseIdList = self.category[indexPath.row].courseIdList!
        
        navigationController?.pushViewController(dest, animated: true)
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
