//
//  ViewController7.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/04/03.
//

import UIKit

class ViewController7: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 700))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .brown
        searchBar = UIView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 200))
        searchBar.backgroundColor = .orange
        scrollView.addSubview(searchBar)
        searchBar.layer.zPosition = 2
        searchBar2 = UIView(frame: CGRect(x: 0, y: 400, width: self.view.bounds.width, height: 200))
        scrollView.addSubview(searchBar2)
        searchBar2.backgroundColor = .blue
        searchBar2.layer.zPosition = 1
        scrollView.delegate = self
        searchBar3 = UIView(frame: CGRect(x: 0, y: 600, width: self.view.bounds.width, height: 200))
        searchBar3.backgroundColor = .white
        searchBar3.layer.zPosition = 0
        scrollView.addSubview(searchBar3)
    
    }
    var scrollView:UIScrollView!
    var searchBar:UIView!
    var searchBar2:UIView!
    var searchBar3:UIView!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("インセット\(scrollView.contentInset.top)")
        print("オフセット\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y >= 100 {
            var move = scrollView.contentOffset.y - 100
            searchBar.frame = CGRect(x: 0, y: move+100, width: self.view.bounds.width, height: 200)
        }
        if scrollView.contentOffset.y >= 200 {
            var move = scrollView.contentOffset.y - 100
            searchBar2.frame = CGRect(x: 0, y: move+300, width: self.view.bounds.width, height: 200)
        }
//        searchBar.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 200)
        print(searchBar.bounds)
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
