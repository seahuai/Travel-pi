//
//  IconCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    var iconAndTip: (icon: String, tip: String)?{
        didSet{
            tipLabel.text = iconAndTip?.tip
            iconImageView.image = UIImage(named: iconAndTip!.icon)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
