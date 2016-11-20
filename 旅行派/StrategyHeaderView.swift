//
//  StrategyHeaderView.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/13.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class StrategyHeaderView: UITableViewHeaderFooterView {
    var text: String?{
        didSet{
            label.text = text
        }
    }
    var selected: Bool = false{
        didSet{
            button.isSelected = selected
        }
    }
    fileprivate lazy var label: UILabel = UILabel()
    fileprivate lazy var button: UIButton = UIButton()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(colorLiteralRed: 46/255, green: 206/255, blue: 248/255, alpha: 0.5)
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.setImage(UIImage(named: "arrow_up"), for: .selected)
        contentView.addSubview(label)
        contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(button.snp.right).offset(10)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(30)
        }
    }

}
