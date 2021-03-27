//
//  TryKitViewController.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/27.
//

import UIKit
import IGListKit

class TryKitViewController: UIViewController,ListAdapterDataSource {
    var data = [ListDiffable]()
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    var collectionView:UICollectionView!
    lazy var adapter:ListAdapter =  {return ListAdapter(updater: ListAdapterUpdater(), viewController: self,workingRangeSize: 1)}()
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return Post2SectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: 700, height: 300)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        data.append(Post2(comments: [Comment2(username: "a", text: "aa"),Comment2(username: "aaa", text: "aa"),]))
        collectionView.backgroundColor = .red
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 90)
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
}


final class Post2:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return comments as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    let comments:[Comment2]
    init(comments:[Comment2]) {
        self.comments = comments
    }
}

final class Comment2:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return username + text as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    let username:String
    let text:String
    init(username:String,text:String) {
        self.username = username
        self.text = text
    }
}


final class Post2SectionController :ListBindingSectionController<Post2>,ListBindingSectionControllerDataSource{
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        switch viewModel {
        case is Comment2:
            let cell4 = collectionContext!.dequeueReusableCell(of: CommentCell2.self, for: self, at: index) as! CommentCell2
            cell4.backgroundColor = .orange
            return cell4
        default:
            fatalError()
        }
    }
    
    override init() {
        super.init()
        dataSource = self
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Post2 else { fatalError() }
        return object.comments
    }

    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        // 1
         guard let width = collectionContext?.containerSize.width else { fatalError() }
         // 2
         let height: CGFloat
         switch viewModel {
//         case is ImageViewModel:
//            height = 50
         case is Comment2: height = 35
         // 3
         default: height = 55
         }
        return CGSize(width: width, height: height)
    }
    
}

final class CommentCell2: UICollectionViewCell,ListBindable{
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Comment2 else {
            return
        }
        usernameLabel.text = viewModel.username
        commentLabel.text = viewModel.text
        
    }
    
    var usernameLabel = UILabel()
    var commentLabel = UILabel()
}
