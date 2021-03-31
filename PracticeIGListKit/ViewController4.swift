//
//  ViewController4.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/31.
//

import UIKit

class ViewController4: UIViewController{

    var myTableView:UITableView!
    lazy var models:Array<Model> = [Model(isShown: false, name: "サッカー", array: ["太郎","太郎","太郎"]),Model(isShown: false, name: "野球", array: ["太郎","太郎","太郎"]),Model(isShown: false, name: "ドッジボール", array: ["太郎","太郎","太郎"])]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300), style: UITableView.Style.grouped)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        myTableView.backgroundColor = .blue
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
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

extension ViewController4:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if models[section].isShown {
            return models[section].array.count
        }else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.section].array[indexPath.row]
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].name
    }
    
}
extension ViewController4:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
               let gesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(headertapped(sender:)))
               headerView.addGestureRecognizer(gesture)
               headerView.tag = section
               return headerView
    }
    @objc func headertapped(sender: UITapGestureRecognizer) {
           guard let section = sender.view?.tag else {
               return
           }
        models[section].isShown.toggle()
         //これ以降で表示、非表示を切り替えます。
         myTableView.beginUpdates()
         myTableView.reloadSections([section], with: .automatic)
         myTableView.endUpdates()
    }
}

struct Model {
    var isShown:Bool
    var name:String
    var array:Array<String>
}

