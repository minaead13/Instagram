//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by Mina on 29/04/2023.
//

import UIKit
import SDWebImage
protocol IGFeedPostHeaderTableViewCellDelegate : AnyObject{
    func didTapButton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    private let profilephoto: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let usernameLabel : UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(profilephoto)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    @objc private func didTapButton(){
        delegate?.didTapButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model : User){
        // configure the cell
        usernameLabel.text = model.username
        profilephoto.image = UIImage(systemName: "person.circle")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.hieght - 4
        profilephoto.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilephoto.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.width-size, y: 2, width: size, height: size)
        
        usernameLabel.frame = CGRect(x: profilephoto.right + 10, y: 2, width: contentView.width-(size*2)-15, height: contentView.hieght-4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilephoto.image = nil
    }

}
