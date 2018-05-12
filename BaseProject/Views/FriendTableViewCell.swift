//
//  FriendTableViewCell.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ friend: Friend)
    {
        self.backgroundView?.backgroundColor = Color.clear
        
        self.userNameLabel.text = friend.name
        self.statusLabel.text = friend.status == .online ? "Online" : "Offline"
        self.statusImageView.image = AppImage.status(online: friend.status == .online).image
        self.avatarImageView.image = AppImage.status(online: false).image
        if let image = friend.smallImageUrl {
            if let urlImage = URL(string: image) {
                self.avatarImageView.kf.setImage(with: urlImage, placeholder: AppImage.status(online: false).image)
            }
        }
        
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.clipsToBounds = true;
        
    }
}
