//
//  ShowSearchCityCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/21.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ShowSearchCityCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    var cellText: String?{
        didSet{
            cityLabel.text = cellText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
