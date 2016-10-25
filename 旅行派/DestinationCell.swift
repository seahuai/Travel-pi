//
//  DestinationCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class DestinationCell: UITableViewCell {
    
    fileprivate lazy var label = UILabel()
    
    var destination: Destination?{
        didSet{
            descriptionLabel.text = destination?._description
            let imageURL = URL(string: destination!.photo_url!)
            desImageView.sd_setImage(with: imageURL, placeholderImage: nil)
            setLabel(text: destination?.name)
        }
    }
    

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var desImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    fileprivate func setLabel(text: String?){
        
        desImageView.addSubview(label)
        label.backgroundColor = UIColor.clear
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        label.snp.makeConstraints { (make) in
            make.width.equalTo(desImageView.snp.width)
            make.centerX.equalTo(desImageView.snp.centerX)
            make.centerY.equalTo(desImageView.snp.centerY)
            make.width.equalTo(44)
        }
        
    }

}
