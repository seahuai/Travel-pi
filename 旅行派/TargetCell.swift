//
//  TargetCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/27.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TargetCell: UITableViewCell {
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var lingganLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    var targetModel: Target?{
        didSet{
            targetLabel.text = targetModel?.title
            lingganLabel.text = targetModel?.summary
            if let urlStr = targetModel?.photo_url{
                let url = URL(string: urlStr)
                targetImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
