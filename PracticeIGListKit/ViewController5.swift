//
//  ViewController5.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/04/01.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import PromiseKit

class ViewController5: UIViewController,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .cyan
        return cell
    }
    
    var collectionView:UICollectionView!
    var progressBar:UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .lightGray
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(collectionView)
        setUp()
    
        
    }
    let viewModel = ViewModel()
    func setUp(){
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.behavior.fetch()
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


class ViewModel{
    let behavior = BehaviorRelay<[LoginMessage]>(value: [LoginMessage]())
    let header = ["Content-Type": "application/json"]
    func fetch() -> Promise<[LoginMessage]>{
        Alamofire.request("http://localhost:8080", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseDecodable([LoginMessage].self)
    }
}

extension BehaviorRelay where Element == [LoginMessage] {
    func fetch(){
        let header = ["Content-Type": "application/json"]
        Alamofire.request("http://localhost:8080/allList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseDecodable([LoginMessage].self).map{
            self.accept($0)
        }
    }
}

