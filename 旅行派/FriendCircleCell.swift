//
//  FriendCircleCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/26.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage

var commentH: CGFloat = 15

class FriendCircleCell: UITableViewCell {

    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picCollectionView: ImagesCollectionView!
    @IBOutlet weak var commentsTableView: CommentsTableView!
    
    @IBOutlet weak var imgsViewWidthCon: NSLayoutConstraint!
    @IBOutlet weak var imgsViewHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var commentsHeightCon: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var friendCircleModel: FriendCircle?{
        didSet{
            nameLabel.text = friendCircleModel!.user
            avatorImageView.sd_setImage(with: friendCircleModel?.avator, placeholderImage: UIImage(named: "profile_g"), options: .progressiveDownload)
            contentLabel.text = friendCircleModel!.content
            
            picCollectionView.imgUrls = friendCircleModel?.imgUrls ?? [URL]()
            commentsTableView.comments = friendCircleModel?.comments ?? [Comment]()
            
            let size = picsViewSize(count: friendCircleModel!.imgUrls.count)
            imgsViewWidthCon.constant = size.width
            imgsViewHeightCon.constant = size.height
            
            let commentsCount = friendCircleModel!.comments.count
            if commentsCount == 0{
                commentsHeightCon.constant = 0
            }else{
                commentsHeightCon.constant = CGFloat(commentsCount) * commentH
            }
            
            var cellHeight: CGFloat = -1
//            print("cellHeight = \(cellHeight)")
            if friendCircleModel!.cellHeight != cellHeight{
                layoutIfNeeded()
                friendCircleModel?.cellHeight = commentsTableView.frame.maxY + 10
                cellHeight = commentsTableView.frame.maxY
            }
        }
    }
}

//MARK:九宫格图片的计算
extension FriendCircleCell{
    func picsViewSize(count: Int) -> CGSize{
        
        let itemDistance: CGFloat = 8
        let edgeDistance: CGFloat = 10
        
        if count == 0{
            return CGSize.zero
        }
        
        layoutIfNeeded()
        let imageViewWH = (nameLabel.frame.width - 2 * itemDistance - 2 * edgeDistance) / 3
        let itemLayout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if count == 1 {//当只有1张图片时，从缓存中取出图片，将size设置为图片的尺寸
            
            
            
            return CGSize.zero
            
        }
        itemLayout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        if count == 4 {//当有4张图片时，将size设置为四宫格
            return CGSize(width: 2 * imageViewWH + itemDistance, height: 2 * imageViewWH + itemDistance)
        }
        
        let rows = (count - 1) / 3 + 1
        return CGSize(width: imageViewWH * 3 + 2 * itemDistance, height: imageViewWH * CGFloat(rows) + CGFloat(rows - 1) * itemDistance )
        
    }
}




