//
//  NearByViewCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/21.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SnapKit
class NearByViewCell: UITableViewCell {

    fileprivate lazy var view = UIView()
    fileprivate lazy var label = UILabel()
    fileprivate lazy var titleLabel = UILabel()
    fileprivate lazy var button = UIButton()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpLabel()
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NearByViewCell{
    
    fileprivate func setUp(){
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(view)
        contentView.addSubview(titleLabel)
        view.addSubview(label)
        view.addSubview(button)
        
        view.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    fileprivate func setUpLabel(){
        label.text = "开启定位来获取周边信息"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        titleLabel.text = "无法获取周边信息"
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(8)
            make.top.equalTo(contentView.snp.top).offset(3)
            make.bottom.equalTo(view.snp.top).offset(-3)
            make.width.equalTo(100)
        }
    }
    
    fileprivate func setUpButton(){
        button.setTitle("去设置", for: .normal)
        button.setTitleColor(globalColor, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(label.snp.centerX)
            make.centerY.equalTo(label.snp.centerY).offset(15)
        }
    }
    
    @objc private func buttonClick(){
        let url = URL(fileURLWithPath: "prefs:root=LOCATION_SERVICES")
        UIApplication.shared.openURL(url)
    }
}
