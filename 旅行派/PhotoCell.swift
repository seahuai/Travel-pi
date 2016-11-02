//
//  PhotoCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage
protocol PhotoCellImageDelegate {
    func photoCellImageClick()
}

class PhotoCell: UICollectionViewCell {
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var tipLabel: UILabel = UILabel()
    
    var delegate: PhotoCellImageDelegate?
    
    var content: Content?{
        didSet{
            if let urlStr = content?.photo_url{
                let url = URL(string: urlStr)
               
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"), options: .progressiveDownload, completed: { (image, error, _, _) in
                    if error != nil || image == nil {print("图片加载失败");return; }
                    self.setUpImageViewSize(size: image?.size)
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotoCell{
    
    fileprivate func setUp(){
        scrollView.frame = contentView.bounds
        contentView.addSubview(scrollView)
//        contentView.addSubview(tipLabel)
        scrollView.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTap))
        imageView.addGestureRecognizer(tapGes)
    }
    
    @objc private func imageViewTap(){
        delegate?.photoCellImageClick()
    }
    
    fileprivate func setUpImageViewSize(size: CGSize?){
        self.layoutIfNeeded()
        let screenBounds = UIScreen.main.bounds.size
        let imageViewH = (screenBounds.width / size!.width) * size!.height
        let imageViewY = (screenBounds.height - imageViewH) * 0.5
        if imageViewY < 0{
            imageView.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: imageViewH)
            scrollView.contentSize = CGSize(width: 0, height: imageViewH)
        }else{
            imageView.frame = CGRect(x: 0, y: imageViewY, width: screenBounds.width, height: imageViewH)
        }
    }

}
