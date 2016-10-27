//
//  picCollectionCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/27.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage

class picCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var destination: Destination?{
        didSet{
            if let photo_url = destination?.photo_url{
                let url = URL(string: photo_url)
                imageView.sd_setImage(with: url, placeholderImage: nil)
            }
            titleLabel.text = destination?.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = 0.2 * imageView.bounds.width
        imageView.layer.masksToBounds = true
    }
    
    

}
