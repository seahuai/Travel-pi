//
//  PhotoBrowserViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SnapKit

class PhotoBrowserViewController: UIViewController {
    
    fileprivate lazy var saveButton = UIButton()
    fileprivate lazy var closeButton = UIButton()
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpButton()
        setUpButtonTarget()
    }

}

extension PhotoBrowserViewController{
    
    fileprivate func setUp(){
//        self.view.layoutIfNeeded()
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
    }
    
    
    fileprivate func setUpButton(){
        
        saveButton.titleLabel?.textAlignment = .center
        saveButton.titleLabel?.textColor = UIColor.white
        saveButton.backgroundColor = UIColor.clear
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
        
        closeButton.titleLabel?.textAlignment = .center
        closeButton.titleLabel?.textColor = UIColor.white
        closeButton.backgroundColor = UIColor.clear
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        
        
        saveButton.setTitle("保存", for: .normal)
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-15)
            make.left.equalTo(view.snp.left).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        closeButton.setTitle("关闭", for: .normal)
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-15)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }

    }
}

extension PhotoBrowserViewController{
    fileprivate func setUpButtonTarget(){
        saveButton.addTarget(self, action: #selector(self.saveButtonClick), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.closeButtonClick), for: .touchUpInside)
    }
    
    
    @objc private func saveButtonClick(){
        print("saveButtonClick")
    }
    
    @objc private func closeButtonClick(){
        print("closeButtonClick")
        dismiss(animated: true) {}
    }
}

class layout: UICollectionViewFlowLayout{
    
    override func prepare() {
        
        itemSize = collectionView!.frame.size
        
        scrollDirection = .horizontal
        minimumLineSpacing = 0
    }
    
    
}
