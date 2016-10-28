//
//  FindMoreCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FindMoreCell: UITableViewCell {
    
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!

    var destination: Destination?{
        didSet{
            nameLabel.text = destination?.name
            if let urlStr = destination?.photo_url{
            let url = URL(string: urlStr)
                backImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            notesCountLabel.text = "- 有999条旅游灵感 -"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backImageView.clipsToBounds = true
    }
}
