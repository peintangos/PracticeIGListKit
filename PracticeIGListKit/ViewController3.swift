//
//  ViewController3.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/28.
//

import UIKit
import Alamofire
import PromiseKit
import RxSwift
import RxCocoa

class ViewController3: UIViewController,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var b = UICollectionViewCell()
        b.backgroundColor = .cyan
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                let a = UIView(frame: self.view.bounds)
                a.backgroundColor = .cyan
                self.view.addSubview(a)
                let ActivityIndicator = UIActivityIndicatorView()
                ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                ActivityIndicator.center = a.center
                ActivityIndicator.style = UIActivityIndicatorView.Style.large
                ActivityIndicator.startAnimating()
                a.addSubview(ActivityIndicator)
                when(fulfilled: fetch(),fetch2()).done{
                    cell.data = $0.0[indexPath.row]
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        a.alpha = 0
                    }) { (completed) in
                        a.removeFromSuperview()
                    }
                }.catch{_ in print("キャッチ")}
            }
            b = cell
        }
        print("既に返却されている")
        return b
    }
    func fetch() -> Promise<[LoginMessage]>{
        return Promise{ seal in
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
                Alamofire.request("http://localhost:8080/allList", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (data) in
                    print("開始")
                                switch data.result {
                                case .success:
                                    let decoder = JSONDecoder()
                                        do {
                                            let decodedData = try decoder.decode([LoginMessage].self, from: data.data!)
                                            seal.fulfill(decodedData)
                                            print("成功")
                                        } catch {
                                            print("失敗1")
                                            print(error)
                                        }
                                case .failure(let error):
                                    seal.reject(error)
                                }
        }
    }
    }
    func fetch2() -> Promise<[LoginMessage]>{
        return Promise{ seal in
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
                Alamofire.request("http://localhost:8080/allList", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (data) in
                    print("開始")
                                switch data.result {
                                case .success:
                                    let decoder = JSONDecoder()
                                        do {
                                            let decodedData = try decoder.decode([LoginMessage].self, from: data.data!)
                                            seal.fulfill(decodedData)
                                            print("成功")
                                        } catch {
                                            print("失敗1")
                                            print(error)
                                        }
                                case .failure(let error):
                                    seal.reject(error)
                                }
        }
    }
    }
    let subject = BehaviorSubject(value: false)
    let dis = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        view2.backgroundColor = .white
        let view3 = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view3.rx.tap.subscribe{ [self] in
            print("s")
            if try! subject.value() {
                print("sdd")
                subject.onNext(false)
            }else {
                print("sd")
                subject.onNext(true)
            }
        }.disposed(by: dis)
        view3.backgroundColor = .purple
        view2.addSubview(view3)
        view.addSubview(view2)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        let colletionView = UICollectionView(frame: CGRect(x: 0, y: 50, width: 300, height: 300), collectionViewLayout: layout)
        colletionView.backgroundColor = .darkGray
        colletionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        colletionView.dataSource  = self
        view.addSubview(colletionView)
        let a = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        subject.asObservable().filter {$0 == true}.subscribe{
            print("d")
            self.view.addSubview(a)
        }.disposed(by: dis)
        
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
struct LoginMessage: Encodable,Decodable{
    var name:String
    var password:String
}
var count = 0
class CollectionViewCell:UICollectionViewCell{
    var a:UILabel!
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        a = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.addSubview(a)
    }
    var data:LoginMessage?{
        didSet{
            guard let data = data else {
                return
            }
            self.a.text = data.name
        }
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
