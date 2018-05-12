//
//  FriendTableViewCell.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

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
        self.userNameLabel.text = friend.name
        self.statusLabel.text = friend.status == .online : "Online" : "Offline"
)
    }
}
