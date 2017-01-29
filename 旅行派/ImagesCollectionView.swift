//
//  ImagesCollectionView.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/29.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class ImagesCollectionView: UICollectionView {

    var imgUrls: [URL] = [URL](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isScrollEnabled = false
        delegate = self
        dataSource = self
    }
    
}

extension ImagesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.url = imgUrls[indexPath.item]
        return cell
    }
}

class ImageCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    
    var url: URL?{
        didSet{
            imageView.sd_setImage(with: url!, placeholderImage: UIImage(named:"empty_picture"), options: .progressiveDownload)
        }
    }
}
