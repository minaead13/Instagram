//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by Mina on 29/04/2023.
//

import UIKit
import SDWebImage
import AVFoundation
/// Cell for primary content
final class IGFeedPostTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostTableViewCell"
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    private let postImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true 
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(postImageView)
        contentView.backgroundColor = .white
        contentView.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post : UserPost){
        // configure the cell
        postImageView.image = UIImage(named: "test")
        
        return
        switch post.postType {
        case .photo:
            // show image
            postImageView.sd_setImage(with: post.postURL)
        case .video:
            // show video
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
        playerLayer.frame = contentView.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }

}
