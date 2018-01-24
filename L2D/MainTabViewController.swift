//
//  MainTabViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/25/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController  {
    
    var userID : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide back button
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(AppDelegate.hasLogin == true){
            
            //create tab profile
            let profileTab = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigator")
            let profileTabBarItem = UITabBarItem(title: "profile", image: UIImage(named: "account"), selectedImage: UIImage(named: "account"))
            profileTab?.tabBarItem = profileTabBarItem
            
            //create my course tab
            let courseTab = self.storyboard?.instantiateViewController(withIdentifier: "MyCourseNavigator")
            let courseTabBarItem = UITabBarItem(title: "my course", image: UIImage(named: "mycourse"), selectedImage: UIImage(named: "mycourse"))
            courseTab?.tabBarItem = courseTabBarItem
            
            
            self.viewControllers?.removeLast() //remove login tab
            self.viewControllers?.append(courseTab!)
            self.viewControllers?.append(profileTab!)
           
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
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
