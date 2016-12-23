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
    @IBOutlet weak var nameEnLabel: UILabel!

    var destination: Destination?{
        didSet{
            nameLabel.text = destination?.name
            nameEnLabel.text = destination?.name_en
            if let urlStr = destination?.photo_url{
            let url = URL(string: urlStr)
                backImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backImageView.clipsToBounds = true
    }
}
