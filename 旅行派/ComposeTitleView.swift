//
//  ComposeTopView.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/8.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {

    private lazy var mainlabel = UILabel()
    private lazy var subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainlabel)
        addSubview(subLabel)
        mainlabel.text = "分享"
        mainlabel.textAlignment = .center
        mainlabel.font = UIFont.systemFont(ofSize: 17)
        subLabel.text = "旅游趣事"
        
        subLabel.textColor = UIColor.lightGray
        subLabel.font = UIFont.systemFont(ofSize: 12)
        subLabel.textAlignment = .center
        mainlabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainlabel.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
