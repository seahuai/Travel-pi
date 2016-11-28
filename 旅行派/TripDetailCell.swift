//
//  TripDetailCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol TripDetailDelegate {
    func showInfoAt(indexPath: IndexPath?)
}


class TripDetailCell: UITableViewCell {
    
    var delegate: TripDetailDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var indexPath: IndexPath?
    var activity: Activity?{
        didSet{
            titleLabel.text = activity?.topic
            if activity?.visit_tip == nil {return}
            tipLabel.text = activity?.visit_tip
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func infoButtonClick(_ sender: AnyObject) {
        delegate?.showInfoAt(indexPath: indexPath)
    }
    
    
}
