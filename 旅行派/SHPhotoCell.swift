//
//  SHPhotoCell.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/9.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage

protocol HandleGestureDelegate {
    func longPress(image: UIImage)
    func tap()
}

class SHPhotoCell: UICollectionViewCell {
    
    fileprivate lazy var imageView = UIImageView()
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var progressView: ProgressView = ProgressView()
    
    var url: URL?{
        didSet{
            let str = url!.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: str)
            setUpImageView(image: image!)
        }
    }

    var delegate: HandleGestureDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SHPhotoCell{
    fileprivate func setUp(){
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        
        progressView.center = contentView.center
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        imageView.isUserInteractionEnabled = true
    }
    
    fileprivate func setUpGesture(){
        let longPrseeGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        scrollView.addGestureRecognizer(longPrseeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCell))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func longPress(){
        if let image = imageView.image{
            delegate?.longPress(image: image)
        }
    }
    
    @objc private func tapCell(){
        delegate?.tap()
    }
    
    fileprivate func setUpImageView(image: UIImage){
        imageView.image = image
        
        let ratio = UIScreen.main.bounds.width / image.size.width
        let width = image.size.width * ratio
        let height = image.size.height * ratio
//        scrollView.contentSize = CGSize(width: width * 1.2, height: height * 1.2)
        var y = (UIScreen.main.bounds.height - height) * 0.5
        if y < 0{
            y = 0
        }
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
}

class ProgressView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progress: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let start = CGFloat(-M_PI_2)
        let end = start + 2 * progress * CGFloat(M_PI)
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let bezier = UIBezierPath(arcCenter: center, radius: rect.width * 0.5, startAngle: start, endAngle: end, clockwise: true)
        bezier.addLine(to: center)
        bezier.close()
        UIColor(white: 1, alpha: 0.7).setFill()
        bezier.fill()
    }
}
