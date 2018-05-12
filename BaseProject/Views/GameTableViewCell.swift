//
//  GameTableViewCell.swift
//  BaseProject
//
//  Created by Admin on 12.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(game: Game)
    {
        self.titleLabel.text = game.embedded?.productInGame?.title ?? ""
        self.avatarImageView.image = AppImage.status(online: false).image
        if let image = game.embedded?.productInGame?.imageUrl {
            if let urlImage = URL(string: image) {
                self.avatarImageView.kf.setImage(with: urlImage, placeholder: AppImage.status(online: false).image)
            }
        }
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
