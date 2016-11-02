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
    
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    //MARK:模型
    var contents: [Content] = [Content](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var saveButton = UIButton()
    fileprivate lazy var closeButton = UIButton()
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpButton()
        setUpButtonTarget()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollToItem(at: selectedIndex , at: .left, animated: false)
    }

}

extension PhotoBrowserViewController{
    
    fileprivate func setUp(){
//        self.view.layoutIfNeeded()
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        view.frame.size.width += 20
        
        collectionView.frame = view.bounds
        collectionView.isPagingEnabled = true
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

extension PhotoBrowserViewController: PhotoCellImageDelegate{
    fileprivate func setUpButtonTarget(){
        saveButton.addTarget(self, action: #selector(self.saveButtonClick), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.closeButtonClick), for: .touchUpInside)
    }
    
    
    @objc private func saveButtonClick(){
        print("saveButtonClick")
    }
    
    @objc private func closeButtonClick(){
//        print("closeButtonClick")
        dismiss(animated: true) {}
    }
    //MARK:PhotoCell的代理方法
    func photoCellImageClick() {
        dismiss(animated: true) {}
    }
}

extension PhotoBrowserViewController: UICollectionViewDataSource{
    
    fileprivate func setUpCollectionView(){
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.content = contents[indexPath.item]
        cell.delegate = self
        return cell
    }
}

class layout: UICollectionViewFlowLayout{
    
    override func prepare() {
        
        itemSize = collectionView!.frame.size
        
        scrollDirection = .horizontal
        minimumLineSpacing = 0
    }
    
    
}
