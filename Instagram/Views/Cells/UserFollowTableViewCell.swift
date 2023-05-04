//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by Mina on 01/05/2023.
//

import UIKit
protocol UserFollowTableViewCellDelegate :AnyObject {
    func didTapFollowUnfollowButton(model:UserRelationship)
}

enum FollowState {
    case Following // indicates the current user is following the other user
    case not_following // indicates the current user is not following the other user 
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {

    static let identifier = "UserFollowTableViewCell"
    
     weak var delegate: UserFollowTableViewCellDelegate?
    
    private var model :UserRelationship?
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "joe"
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.text = "@Joe"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let followButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(profileImageView)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapfFollowButton), for: .touchUpInside)
    }
    @objc private func didTapfFollowButton(){
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model :UserRelationship){
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = model.username
        switch model.type {
        case .Following:
            // show unfollow button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
            followButton.setTitleColor(.label, for: .normal)
        case .not_following:
            // show unfollow button
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 1
            followButton.setTitleColor(.white, for: .normal)
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.hieght-6, height: contentView.hieght-6)
        profileImageView.layer.cornerRadius = profileImageView.hieght/2.0
        
        let buttonWidth = contentView.width > 500 ? 220 : contentView.width/3 // for ipad
        followButton.frame = CGRect(x: contentView.width-5-buttonWidth, y: (contentView.hieght-40)/2, width: buttonWidth, height: 40)
        
        let labelHeight = contentView.hieght/2
        nameLabel.frame = CGRect(x: profileImageView.right+5, y: 0, width: contentView.width-8-profileImageView.width-buttonWidth, height: labelHeight)
        usernameLabel.frame = CGRect(x: profileImageView.right+5, y: nameLabel.bottom, width: contentView.width-8-profileImageView.width-buttonWidth, height: labelHeight)
        
    }
    
    
    
}
