//
//  ViewController2.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/27.
//

import UIKit
import IGListKit

class ViewController2: UIViewController,ListAdapterDataSource {
    var collectionView:UICollectionView!
    lazy var listAdapter:ListAdapter = {return ListAdapter(updater: ListAdapterUpdater(), viewController: self)}()
    var data = [ListDiffable]()
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 100, width: 1000, height: 400)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 90)
        listAdapter.collectionView = collectionView
        listAdapter.dataSource = self
        self.view.backgroundColor = .red
        view.addSubview(collectionView)        
        data.append(Feed(user: [User(name: "a2", comment: "a"),User(name: "add2", comment: "a"),User(name: "dda2", comment: "add")]))
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
final class Feed:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return "users" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    let user:[User]
    init(user:[User]) {
        self.user = user
    }
}
final class User:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return name + comment as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? User else {
            return false
        }
        return name == object.name && comment == object.comment
    }
    
    let name:String
    let comment:String
    
    init(name:String,comment:String) {
        self.name = name
        self.comment = comment
    }
}

final class FeedModel:ListDiffable{
    let name:String
    let commnet:String
    init(name:String,comment:String) {
        self.name = name
        self.commnet = comment
    }
    func diffIdentifier() -> NSObjectProtocol {
        return "feed" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? FeedModel else {
            return false
        }
        return name == object.name && commnet == object.commnet
    }
}

final class SectionController:ListBindingSectionController<Feed>,ListBindingSectionControllerDataSource{
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Feed else {
            fatalError()
        }
        let st = object.user.map { (aa) in
            FeedModel(name: aa.name, comment: aa.comment)
        }
        let results:[ListDiffable] = st
        return results
    }
    override init() {
        super.init()
        dataSource = self
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        switch viewModel {
        case is FeedModel:
            let cell = collectionContext?.dequeueReusableCell(of: FeedCell.self, for: self, at: index) as! FeedCell
            cell.backgroundColor = .blue
            return cell
        default:
            fatalError()
        }
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let _ = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: 100, height: 100)
    }
}

final class FeedCell:UICollectionViewCell,ListBindable{
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FeedModel else { return }
        self.backgroundColor = .brown
    }
}
