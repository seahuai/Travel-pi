//
//  AlbumPicCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class AlbumPicCell: UICollectionViewCell {

    var urlStr: String?{
        didSet{
            if let urlStr = urlStr{
                let url = URL(string: urlStr)
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

}
