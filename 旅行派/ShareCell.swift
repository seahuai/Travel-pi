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
    
    @IBOutlet weak var picCollectionViewHeightCon: NSLayoutConstraint!
    
    var contents: [Content] = [Content]()
    var note: TravelNote?{
        didSet{
            if let urlStr = note?._user?.photo_url{
                let url = URL(string: urlStr)
                headImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            nameLabel.text = note?._user?.name
            
            titleLabel.text = note?.topic
            descripationLabel.text = note?._description
            
            
            guard  let contents = note?._contents else {
                picCollectionView.bounds.size.height = 0
                return
            }
            
            if let urlStr = contents[0].photo_url{
                let url = URL(string: urlStr)
                mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
            }
            
            self.contents = contents
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setUpPicCollectionView()
//        setUpCellSize()
    }

}

extension ShareCell{
    
    fileprivate func setUpCellSize(){
        descripationLabel.bounds.size.height = 80
    }
    
    
    fileprivate func setUp(){
        self.layoutIfNeeded()
        
        readAllButton.layer.cornerRadius = 5
        readAllButton.layer.masksToBounds = true
        readAllButton.layer.borderWidth = 1
        readAllButton.layer.borderColor = UIColor.lightGray.cgColor
        
        headImageView.layer.cornerRadius = headImageView.frame.height * 0.5
        print(headImageView.frame.height)
        headImageView.layer.masksToBounds = true
        readAllButton.layer.borderWidth = 1
        readAllButton.layer.borderColor = UIColor.white.cgColor
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
        if let count = note?._contents.count{ return count - 1 }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCell
        
        cell.photo_url = contents[indexPath.row + 1].photo_url
        
        return cell
    }
    
    
}






