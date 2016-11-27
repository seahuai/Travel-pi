//
//  DayCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/26.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    
    var _descripation: String?{
        didSet{
            firstDayLabel.text = _descripation
        }
    }
    
    var title: String?{
        didSet{
            titleLable.text = title
        }
    }
    
    var url: URL?{
        didSet{
        titleImageView.sd_setImage(with: url, placeholderImage: nil)
        }
    }
    
    var plan: Plan?{
        didSet{
            titleLable.text = plan?.title
//            print(plan?.photo_url)
            if let urlStr = plan?.photo_url{
                let url = URL(string: urlStr)
                titleImageView.sd_setImage(with: url, placeholderImage: nil)
            }else if let urlStr = plan?._days[0].activities[0].photo_url{
                let url = URL(string: urlStr)
                titleImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            firstDayLabel.text = plan?._days[0]._description
        }
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
