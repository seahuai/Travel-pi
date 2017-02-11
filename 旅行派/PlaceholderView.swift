//
//  PlaceholderView.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/11.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

protocol PlaceholderLoginDelegate {
    func login()
}

class PlaceholderView: UIView {

    fileprivate lazy var label = UILabel()
    fileprivate lazy var button = UIButton()
    fileprivate lazy var imageView = UIImageView()
    
    var delegate: PlaceholderLoginDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let x = frame.width * 0.5
//        let y = frame.height * 0.5
        label.frame = CGRect(x: 0, y: 100, width: frame.width, height: 44)
        button.frame = CGRect(x: 0, y: 150, width: frame.width, height: 44)
        imageView.frame = CGRect(x: x - 25, y: 40, width: 50, height: 50)
    }
    
    fileprivate func setUp(){
        backgroundColor = UIColor.white
        
        addSubview(label)
        label.text = "尚未登录"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 20, weight: 7)
        label.textAlignment = .center
        
        addSubview(button)
        button.setTitle("前往登录", for: .normal)
        button.setTitleColor(globalColor, for: .normal)
        button.addTarget(self, action: #selector(self.goLogin), for: .touchUpInside)
        
        addSubview(imageView)
        imageView.image = UIImage(named: "key_error")
    }
    
    @objc private func goLogin(){
        delegate?.login()
    }
    
    
}
