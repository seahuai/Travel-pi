//
//  RouteCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/12.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

protocol RouteCellDelegate {
    func goWalk()
    func byBus()
    func byCar()
}

class RouteCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var delegate: RouteCellDelegate?
    
    var info: RouteModel?{
        didSet{
            nameLabel.text = info?.name ?? "暂无名称"
            addressLabel.text = info?.address ?? "暂无地址"
            phoneLabel.text = info?.phone ?? "暂无联系电话"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
    }
}


extension RouteCell{
    @IBAction func walkButtonClick(_ sender: AnyObject) {
        delegate?.goWalk()
    }
    
    @IBAction func busButtonClick(_ sender: AnyObject) {
        delegate?.byBus()
    }
    
    @IBAction func driveButtonClick(_ sender: AnyObject) {
        delegate?.byCar()
    }
}
