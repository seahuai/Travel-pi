
//
//  PickViewCell.swift
//  微博
//
//  Created by 张思槐 on 16/9/18.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class PickImageCell: UICollectionViewCell {

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
    
    @IBAction func deleteButtonClick(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteImageNote"), object: nil, userInfo: ["image": image])
    }
    
    @IBAction func chooseButtonClick(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChooseImageNote"), object: nil, userInfo: nil)
    }
    

}
