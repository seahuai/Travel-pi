//
//  DescripationView.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SnapKit

class DescripationView: UIView {

    fileprivate lazy var textView: UITextView = UITextView()
    fileprivate lazy var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescripationView{
    
    fileprivate func setUpConstraints(){
        addSubview(textView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(15)
            make.left.equalTo(self.snp.left).offset(10)
        }
        
        textView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
    }
    
    fileprivate func setUp(){
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        
        titleLabel.text = "图片简述："
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    func set(text: String?){
        textView.text = text
    }
}
