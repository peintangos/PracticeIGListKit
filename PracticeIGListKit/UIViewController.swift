//
//  UIViewController.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/27.
//

import UIKit

class UIViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let col = UICollectionView(frame: CGRect(x: 100, y: 0, width: 1000, height: 100), collectionViewLayout: UICollectionViewLayout())
        
        view.addSubview(col)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
