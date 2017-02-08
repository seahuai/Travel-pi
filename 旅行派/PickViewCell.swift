
//
//  PickViewCell.swift
//  微博
//
//  Created by 张思槐 on 16/9/18.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PickViewCell: UICollectionViewCell {

    var image: UIImage?{
        didSet{
            if image == nil{
                deleteButton.isHidden = true
                chooseButton.isHidden = false
                imageView.image = nil
            }else{
                deleteButton.isHidden = false
                chooseButton.isHidden = true
                imageView.image = image
            }
        }
    }
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
//    //在pickViewCell中
//    @IBAction func ChooseImageButtonClick(sender: AnyObject) {
//        NotificationCenter.default.postNotificationName(ChooseImageNote, object: nil)
//    }
//    @IBAction func DeleteImageButtonClick(sender: AnyObject) {
//        NSNotificationCenter.defaultCenter().postNotificationName(DeleteImageNote, object: image)
//    }

}
