//
//  ViewController6.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/04/01.
//

import UIKit
import PromiseKit
import Alamofire
import RxSwift
import RxCocoa

class ViewController6: UIViewController {
    var tableView:UITableView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 400, height: 400), style: UITableView.Style.grouped)
        let viewModel = ViewModel2()
//        var da = viewModel.subject.asObservable()
//        let data = Observable<[String]>.just(["first element", "second element", "third element"])

        viewModel.subject.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
            cell.textLabel?.text = model.name
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            viewModel.subject.fetch()
        }
        var a = UIView(frame: self.view.bounds)
        tableView.rx.itemSelected.subscribe { (event) in
            firstly {
                viewModel.fetchS(viewController: self,a:a)
            }.done { (array) in
                aaa = 0
                UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
//                    a.alpha = 0
                }) { (completed) in
                    a.removeFromSuperview()
                }
                self.present(A(tt: Param(section: event.element!.section.description, index: event.element!.row.description)), animated: true, completion: nil)
            }.catch { (error) in
                print(error)
            }
        }.disposed(by: disposeBag)
        
        progressBar = Bar(progressViewStyle: UIProgressView.Style.default)
        progressBar = Bar(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 300))
        self.view.addSubview(progressBar)
        
        countUp = UIButton(frame: CGRect(x: 0, y: 400, width: 100, height: 100))
        countUp.backgroundColor = .red
        countDown = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        countDown.backgroundColor = .purple
        self.view.addSubview(countUp)
        self.view.addSubview(countDown)
        
        let behavoirStepbarSubject = BehaviorSubject<Float>(value: 0)
        
        behavoirStepbarSubject.asObservable().bind(to: progressBar.rx.progress).disposed(by: disposeBag)
        
        countDown.rx.tap.subscribe{ [self] _ in
//            RxをAnimationさせる方法が分からないので、一旦これで良いか。
            progressBar.setProgress(progressBar.progress + 0.1, animated: true)
        }.disposed(by: disposeBag)
        
        countUp.rx.tap.subscribe{ [self] _ in
            behavoirStepbarSubject.onNext(progressBar.progress - 0.1)
        }.disposed(by: disposeBag)
        

    }
    var progressBar:Bar!
    var countUp:UIButton!
    var countDown:UIButton!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Bar :UIProgressView{
    override func setProgress(_ progress: Float, animated: Bool) {
        UIView.animate(withDuration: 2) {
            super.setProgress(progress, animated: animated)
        }
    }
}
class ViewModel2{
    let subject = BehaviorRelay<[LoginMessage]>(value: [LoginMessage]())
    func fetchS(_ : (()-> Void)? = nil,viewController:UIViewController,a:UIView) ->Promise<[LoginMessage]>{
        aaa += 1
        if aaa == 1 {
            a.backgroundColor = .cyan
            viewController.view.addSubview(a)
            let ActivityIndicator = UIActivityIndicatorView()
            ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            ActivityIndicator.center = a.center
            ActivityIndicator.style = UIActivityIndicatorView.Style.large
            ActivityIndicator.startAnimating()
            a.addSubview(ActivityIndicator)
        }
        
        let header = ["Content-Type": "application/json"]
        print("きてる1")
        return Promise{ seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Alamofire.request("http://localhost:8080/allList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (data) in
                    switch data.result {
                    case .success:
                        let decoder = JSONDecoder()
                            do {
                                let decodedData = try decoder.decode([LoginMessage].self, from: data.data!)
                                seal.fulfill(decodedData)
                                print("成功")
                            } catch {
                                print("失敗")
                            }
                    case .failure(let error):
                        print("キャッチ")
                        return seal.reject(error)
                    }
                }
            }
        }
    }
    
}

class BaseViewContrller<T>:UIViewController{
    var t :T!
    init(tt:T) {
        super.init(nibName: nil, bundle: nil)
        t = tt
        self.view.backgroundColor = .purple
    }
    override func viewDidLoad() {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Param{
    let section:String
    let index:String
}

class A:BaseViewContrller<Param>{
    override func viewDidLoad() {
        let a = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        a.text = t.index
        self.view.addSubview(a)
    }
}

var aaa = 0

class StepbarManager {
    // 自動的に遅延初期化される(初回アクセスのタイミングでインスタンス生成)
    static let stepbarManager = StepbarManager()
    // 外部からのインスタンス生成をコンパイルレベルで禁止
    private init() {}
}
