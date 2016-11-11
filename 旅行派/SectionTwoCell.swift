//
//  SectionTwoCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class SectionTwoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var item: BMKPoiInfo?{
        didSet{
            nameLabel.text = item?.name
            tleLabel.text = item?.phone
            addressLabel.text = item?.address
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
