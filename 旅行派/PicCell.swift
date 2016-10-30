//
//  PicCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/29.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PicCell: UICollectionViewCell {

    var photo_url: String?{
        didSet{
            let url = URL(string: photo_url!)
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

}
