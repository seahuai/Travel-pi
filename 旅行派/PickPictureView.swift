//
//  PickPictureView.swift
//  微博
//
//  Created by 张思槐 on 16/9/18.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PickPictureView: UICollectionView {

    private let cellIdentifier = "pickViewCell"
    var images: [UIImage] = [UIImage](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        setUp()
    }

}

extension PickPictureView{
    
    fileprivate func setUp(){
        register(UINib(nibName: "PickViewCell",bundle: nil), forCellWithReuseIdentifier: "PickViewCell")
        
        let edge: CGFloat = 15
        let itemLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edge) / 3
        itemLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        contentInset = UIEdgeInsets(top: edge, left: edge, bottom: 0, right: edge)
    }
}


//MARK:UICollectionViewDataSource
extension PickPictureView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickViewCell", for: indexPath) as! PickViewCell
        cell.backgroundColor = UIColor.clear
        cell.image = indexPath.item < images.count ? images[indexPath.item] : nil
        
        return cell
    }
}
