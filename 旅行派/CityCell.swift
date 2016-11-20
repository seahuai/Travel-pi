//
//  CityCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class CityCell: UICollectionViewCell {

    @IBOutlet weak var cityButton: UIButton!
    var id: Int = 0
    var cityName: String?{
        didSet{
            cityButton.setTitle(cityName, for: .normal)
        }
    }
    var coordinate: CLLocationCoordinate2D?
    override func awakeFromNib() {
        super.awakeFromNib()
        cityButton.layer.cornerRadius = 5
        cityButton.addTarget(self, action: #selector(self.cityButtonClick), for: .touchUpInside)
    }
    
    @objc private func cityButtonClick(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeCityNote"), object: nil, userInfo: ["id": id, "coordinate": coordinate, "cityName" : cityName])
    }

}
