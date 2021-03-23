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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var adapter:ListAdapter =  {return ListAdapter(updater: ListAdapterUpdater(), viewController: self)}()
    
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
        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        data.append(Post(username: "a", timestamp: "b", image: UIImage(systemName: "square.and.arrow.up")!, likes: 111, comments: [Comment(username: "a", text: "s"),Comment(username: "d", text: "q")]))
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
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
            return collectionContext!.dequeueReusableCell(of: UserCell.self, for: self, at: index) as! UserCell
        case is ImageViewModel:
            return collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
        case is ActionViewModel:
            return collectionContext!.dequeueReusableCell(of: ActionCell.self, for: self, at: index) as! ActionCell
        case is Comment:
            return collectionContext!.dequeueReusableCell(of: CommentCell.self, for: self, at: index) as! CommentCell
        default:
            fatalError()
        }
    }
    
    override init() {
        super.init()
        dataSource = self
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
         // 2
         let height: CGFloat
         switch viewModel {
         case is ImageViewModel: height = 250
         case is Comment: height = 35
         // 3
         default: height = 55
         }
         return CGSize(width: width, height: height)
    }
    
}
//extension UICollectionViewCell:ListBindable{
    

final class ImageCell:UICollectionViewCell,ListBindable{
    var imageView:UIImage!
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ImageViewModel else { return }
        imageView = viewModel.image
    }
    
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
    var usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    var dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? UserViewModel else {
            return
        }
        usernameLabel.text = viewModel.username
        dateLabel.text = viewModel.timestamp
        self.addSubview(usernameLabel)
        self.addSubview(dateLabel)
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

