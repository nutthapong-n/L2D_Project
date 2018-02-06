//
//  CategoryViewController.swift
//  L2D
//
//  Created by Watcharagorn mayomthong on 7/31/2560 BE.
//  Copyright © 2560 Watcharagorn mayomthong. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController ,UICollectionViewDataSource ,UICollectionViewDelegate {
    
    var cate:[Category] = Category.getAllCat()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cate.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cate_list", for: indexPath) as! CategoryCollectionViewCell
        let index = indexPath.item
        let thisCate = cate[index]
        
        
        //set button image and label
        cell.CateLabel.text = thisCate.name
        cell.img_btn.setBackgroundImage(UIImage(named: "keyboard"), for: .normal)
        
        //add shadow
        cell.shadowBox.layer.shadowColor = UIColor.black.cgColor
        cell.shadowBox.layer.shadowOffset = CGSize(width:0, height:0)
        cell.shadowBox.layer.shadowOpacity = 0.7
        cell.shadowBox.layer.shadowRadius = 2
        
        return cell
        
        
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
