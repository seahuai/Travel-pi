//
//  PoiResultCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/10.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

protocol PoiResultCellDelegate {
    func down()
}

class PoiResultCell: UICollectionViewCell {

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: PoiResultCellDelegate?
    var order: Int?{
        didSet{
            orderLabel.text = "- \(order!) -"
        }
    }
    var info: BMKPoiInfo?{
        didSet{
        switch info!.epoitype {
            case 0:
                typeLabel.text = "普通"
            case 1:
                typeLabel.text = "公交站"
            case 2:
                typeLabel.text = "公交线路"
            case 3:
                typeLabel.text = "地铁"
            case 4:
                typeLabel.text = "地铁线路"
            default:
                typeLabel.text = "未知"
            }
            
            nameLabel.text = info?.name
            addressLabel.text = info?.address
            phoneLabel.text = info?.phone
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
        
    }
    
    fileprivate func setUpButton(){
        downButton.addTarget(self, action: #selector(self.down), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.add), for: .touchUpInside)
    }
    
    @objc private func down(){
        delegate?.down()
    }
    
    @objc private func add(){
        
    }

}
