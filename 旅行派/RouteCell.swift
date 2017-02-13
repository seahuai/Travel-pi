//
//  RouteCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/12.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

protocol RouteCellDelegate {
    func goWalk(name: String, location: CLLocationCoordinate2D)
    func byBus(name: String, location: CLLocationCoordinate2D)
    func byCar(name: String, location: CLLocationCoordinate2D)
}

class RouteCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    
    var delegate: RouteCellDelegate?
    var hiddenButton: Bool = false{
        didSet{
            walkButton.isHidden = hiddenButton
            busButton.isHidden = hiddenButton
            carButton.isHidden = hiddenButton
        }
    }
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
        delegate?.goWalk(name: info?.name ?? "未知", location: info!.location!)
    }
    
    @IBAction func busButtonClick(_ sender: AnyObject) {
        delegate?.byBus(name: info?.name ?? "未知", location: info!.location!)
    }
    
    @IBAction func driveButtonClick(_ sender: AnyObject) {
        delegate?.byCar(name: info?.name ?? "未知", location: info!.location!)
    }
}
