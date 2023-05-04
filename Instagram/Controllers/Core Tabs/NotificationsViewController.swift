//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Mina on 25/04/2023.
//

import UIKit

enum UserNotificationType {
    case like(post : UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type : UserNotificationType
    let text : String
    let user : User
}

final class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private var models = [UserNotification]()
    
    private lazy var noNotifications =  NoNotificationsView ()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        //view.addSubview(noNotifications)
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
       // layoutNoNotificationsView()
    }
    
    private func fetchNotifications(){
        for x in 0...100{
            let user = User(username: "joe", bio: "", name: (first: "", last: ""), profilePhoto: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinedDate: Date())
            
            let post = UserPost(identifier: "", postType: .photo, thumbnailImage: URL(string: "https://www.google.com/")!, postURL: URL(string: "https://www.google.com/")!, caption: nil, likeCount: [], createdDate: Date(), comments: [], taggedUsers: [], owner: user)
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following), text: "Hello World", user: user)
            
            models.append(model)
        }
    }
    
    private func addtNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotifications.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotifications.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
           // cell.configure(with: model)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NotificationsViewController : NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        print("Tapped post")
        switch model.type {
            // open the post
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never called")
        }
    }
}

extension NotificationsViewController : NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotification) {
        print("Tapped Button")
        // perform database update
    }
    
    
    
    
    
    
}

