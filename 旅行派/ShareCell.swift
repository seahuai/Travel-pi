//
//  ShareCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/29.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class ShareCell: UITableViewCell {
    
    @IBOutlet weak var unfoldeAllButton: UIButton!
    @IBOutlet weak var readAllButton: UIButton!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descripationLabel: UILabel!
    
    var note: TravelNote?{
        didSet{
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setUpPicCollectionView()
    }

}

extension ShareCell{
    
    fileprivate func setUp(){
        readAllButton.layer.cornerRadius = 5
        readAllButton.layer.masksToBounds = true
        readAllButton.layer.borderWidth = 1
        readAllButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    fileprivate func setUpPicCollectionView(){
        
        picCollectionView.layoutIfNeeded()
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        layout.minimumLineSpacing = space
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: picCollectionView.bounds.height / 0.6, height: picCollectionView.bounds.height - 2 * space)
        
        
//        picCollectionView.showsVerticalScrollIndicator = false
        picCollectionView.showsHorizontalScrollIndicator = false
        picCollectionView.collectionViewLayout = layout
        picCollectionView.dataSource = self
        picCollectionView.delegate = self
        
        picCollectionView.register(UINib(nibName: "PicCell", bundle: nil), forCellWithReuseIdentifier: "PicCell")
    }
    
    
    
    
}


extension ShareCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = note?._contents.count{return count - 1}
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCell
        return cell
    }
    
    
}






