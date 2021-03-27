

//
//  ViewController.swift
//  PracticeIGListKit
//
//  Created by 松尾淳平 on 2021/03/21.
//

import UIKit
import IGListKit

class ViewController: UIViewController,ListAdapterDataSource {
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
        return PostSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 100)
//        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        data.append(Post(username: "a", timestamp: "b", image: UIImage(systemName: "square.and.arrow.up")!, likes: 111, comments: [Comment(username: "a", text: "s"),Comment(username: "d", text: "q")]))
        collectionView.backgroundColor = .red
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 90)
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        a.backgroundColor = .white
    
//        view.addSubview(a)
//        a.addTarget(self, action: #selector(next2), for: UIControl.Event.touchUpInside)
    }
    var a = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 300))
    @objc func next2(){
        self.present(ViewController2(), animated: true, completion: nil)
    }
}


final class Post:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return username + timestamp as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    let username:String
    let timestamp:String
    let image:UIImage
    let likes:Int
    let comments:[Comment]
    init(username:String,timestamp:String,image:UIImage,likes:Int,comments:[Comment]) {
        self.username = username
        self.timestamp = timestamp
        self.image = image
        self.likes = likes
        self.comments = comments
    }
}

final class Comment:ListDiffable{
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

final class UserViewModel:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return "user" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UserViewModel else {
            return false
        }
        return username == object.username && timestamp == object.timestamp
    }
    
    let username:String
    let timestamp:String
    init (username:String,timestamp:String) {
        self.username = username
        self.timestamp = timestamp
    }
}

final class ImageViewModel:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return "image" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ImageViewModel else {
            return false
        }
        return image == object.image
    }
    
    let image:UIImage
    init(image:UIImage) {
        self.image = image
    }
}
final class ActionViewModel:ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return "action" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ActionViewModel else {
            return false
        }
        return likes == object.likes
    }
    
    let likes:Int
    init(likes:Int) {
        self.likes = likes
    }
}

final class PostSectionController :ListBindingSectionController<Post>,ListBindingSectionControllerDataSource{
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        switch viewModel {
        case is UserViewModel:
            let cell = collectionContext!.dequeueReusableCell(of: UserCell.self, for: self, at: index) as! UserCell
            cell.backgroundColor = .blue
            return cell
        case is ImageViewModel:
            let cell2 = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
            cell2.backgroundColor = .gray
            return cell2
        case is ActionViewModel:
            let cell3 = collectionContext!.dequeueReusableCell(of: ActionCell.self, for: self, at: index) as! ActionCell
            cell3.backgroundColor = .yellow
            return cell3
        case is Comment:
            let cell4 = collectionContext!.dequeueReusableCell(of: CommentCell.self, for: self, at: index) as! CommentCell
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
        guard let object = object as? Post else { fatalError() }
        let results: [ListDiffable] = [
          UserViewModel(username: object.username, timestamp: object.timestamp),
            ImageViewModel(image: UIImage(systemName: "stop")!),
          ActionViewModel(likes: object.likes)
        ]
        // 3
        return results + object.comments
    }

    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        // 1
         guard let width = collectionContext?.containerSize.width else { fatalError() }
        print(width)
         // 2
//         let height: CGFloat
//         switch viewModel {
//         case is ImageViewModel:
//            height = 100
//            return CGSize(width: width, height: height)
//         case is Comment: height = 35
//            return CGSize(width: width, height: height)
//         // 3
//         default: height = 55
//            return CGSize(width: width, height: height)
//         }
        return CGSize(width: 200, height: 100)
    }
    
}
//extension UICollectionViewCell:ListBindable{
    

final class ImageCell:UICollectionViewCell,ListBindable{
    var imageView:UIImage!
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ImageViewModel else { return }
        imageView = viewModel.image
        usernameLabel.text = "s"
        usernameLabel.backgroundColor = .green
        dateLabel.backgroundColor = .link
        dateLabel.text = "s"
        self.addSubview(usernameLabel)
        self.addSubview(dateLabel)
    }
    var usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    
}

final class CommentCell: UICollectionViewCell,ListBindable{
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Comment else {
            return
        }
        usernameLabel.text = viewModel.username
        commentLabel.text = viewModel.text
        
    }
    
    var usernameLabel = UILabel()
    var commentLabel = UILabel()
}

final class UserCell:UICollectionViewCell, ListBindable{
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? UserViewModel else {
            return
        }
    }
}

final class ActionCell:UICollectionViewCell,ListBindable{
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ActionViewModel else { return }
            likesLabel.text = "\(viewModel.likes)"
        }
    var likesLabel = UILabel()
    var likesButton = UIButton()
}

