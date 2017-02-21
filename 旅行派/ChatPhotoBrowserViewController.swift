//
//  ChatPhotoBrowserViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/21.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatPhotoBrowserViewController: UIViewController {

    fileprivate var image: UIImage?
    fileprivate lazy var imageView = UIImageView()
    fileprivate lazy var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        
        setUpImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatPhotoBrowserViewController{
    
    fileprivate func setUpImageView(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.frame = UIScreen.main.bounds
        
        let w = UIScreen.main.bounds.width
        let h = (w / image!.size.width) * image!.size.height
        let y = (UIScreen.main.bounds.height - h) * 0.5
        if y < 0{
            imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            scrollView.contentSize = CGSize(width: 0, height: h)
        }else{
            imageView.frame = CGRect(x: 0, y: y, width: w, height: h)
            scrollView.contentSize = CGSize(width: 0, height: 0)
        }
        
        imageView.image = image
    }
    
    
    fileprivate func setUp(){
        view.backgroundColor = UIColor.white
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.saveImage))
        imageView.addGestureRecognizer(longPress)
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
  
    
    @objc private func saveImage(){
        
        if let image = image{
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let save = UIAlertAction(title: "保存图片", style: .default, handler: { (_) in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            })
            
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                ac.dismiss(animated: true, completion: nil)
            })
            ac.addAction(cancle)
            ac.addAction(save)
            present(ac, animated: true, completion: nil)
        }
    }
    
    func image(image: UIImage?, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error == nil{
            SVProgressHUD.showSuccess(info: "保存成功", interval: 0.5)
        }else{
            SVProgressHUD.showError(error: "保存失败", interval: 0.5)
        }
    }
}
