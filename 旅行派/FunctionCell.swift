//
//  FunctionCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/4.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FunctionCell: UITableViewCell {
    
//    var badgeIsHidden: Bool = true{
//        didSet{
//            badge.isHidden = badgeIsHidden
//        }
//    }
    var isExit: Bool = false{
        didSet{
            if isExit{
                functionLabel.textColor = UIColor.red
            }else{
                functionLabel.textColor = UIColor.black
            }
        }
    }
    
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var badge: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
