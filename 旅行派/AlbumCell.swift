//
//  AlbumCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {

//    @IBOutlet weak var descripationTextView: UITextView!
    @IBOutlet weak var descripationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    var note: TravelNote?{
        didSet{
            if let note = note{
                contents = note._contents
                titleLabel.text = note.topic
                descripationLabel.text = note._description
//                descripationTextView.text = note._description
            }
            
        }
    }
    fileprivate var contents: [Content] = [Content](){
        didSet{
            if let urlStr = contents[0].photo_url{
                let url = URL(string: urlStr)
                backGroundImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        picCollectionView.dataSource = self
        picCollectionView.register(UINib(nibName: "AlbumPicCell", bundle: nil), forCellWithReuseIdentifier: "AlbumPicCell")
        picCollectionView.showsHorizontalScrollIndicator = false
        picCollectionView.isPagingEnabled = true
        picCollectionView.collectionViewLayout = collectionViewLayout()
        picCollectionView.backgroundColor = UIColor.clear
    }

}

extension AlbumCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPicCell", for: indexPath) as! AlbumPicCell
        cell.urlStr = contents[indexPath.item].photo_url
        return cell
    }
    
    fileprivate func collectionViewLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds
        layout.itemSize = CGSize(width: screen.width, height: self.bounds.height * 0.4)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }
}
