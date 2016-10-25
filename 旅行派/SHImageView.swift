//
//  SHImageView.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SnapKit
class SHImageView: UIImageView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    fileprivate lazy var label = UILabel()
    var labelText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.darkGray
        addSubview(label)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
       
        label.text = labelText
        label.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(self.snp.width)
        }
        
    }
}
