//
//  ShareCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/29.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage

protocol ShareCellImageDelegate {
    func mainImageClick(row: Int)
    func picImageClick(row: Int, item: Int)
}

class ShareCell: UITableViewCell {
    
    var indexPathRow: Int = 0
    var delegate: ShareCellImageDelegate?
    
    
    @IBOutlet weak var unfoldeAllButton: UIButton!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descripationLabel: UILabel!
    
    @IBOutlet weak var picCollectionViewHeightCon: NSLayoutConstraint!
    @IBOutlet weak var descripationLabelHeightCon: NSLayoutConstraint!
    var contents: [Content] = [Content](){
        didSet{
            picCollectionView.reloadData()
        }
    }
    
    var note: TravelNote?{
        didSet{
            
            if let urlStr = note?._user?.photo_url{
                let url = URL(string: urlStr)
                headImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            nameLabel.text = note?._user?.name
            
            titleLabel.text = note?.topic
            descripationLabel.text = note?._description
            
            descripationLabelHeightCon.constant = note?.labelHeight ?? 80
            
            if let isFold = note?.isFold{
                unfoldeAllButton.isHidden = isFold
            }
            
            guard  let contents = note?._contents else {
                picCollectionView.bounds.size.height = 0
                return
            }
            
            if let urlStr = contents[0].photo_url{
                let url = URL(string: urlStr)
                mainImageView.isUserInteractionEnabled = false
                mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"), options: [], completed: { (_, _, _, _) in
                    self.mainImageView.isUserInteractionEnabled = true
                })
            }
            
            self.contents = contents
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setUpPicCollectionView()
        setUpButton()
        
        setUpMainImage()
//        setUpCellSize()
    }

}
//MARK:初始化设置
extension ShareCell{
    
    fileprivate func setUpCellSize(){
        descripationLabel.bounds.size.height = 80
    }
    
    
    fileprivate func setUp(){
        self.layoutIfNeeded()
        
//        readAllButton.layer.cornerRadius = 5
//        readAllButton.layer.masksToBounds = true
//        readAllButton.layer.borderWidth = 1
//        readAllButton.layer.borderColor = UIColor.lightGray.cgColor
        
        headImageView.layer.cornerRadius = headImageView.frame.height * 0.5
        headImageView.layer.masksToBounds = true
//        readAllButton.layer.borderWidth = 1
//        readAllButton.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func setUpPicCollectionView(){
        
        picCollectionView.layoutIfNeeded()
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 3
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





extension ShareCell{
    fileprivate func setUpButton(){
        unfoldeAllButton.addTarget(self, action: #selector(self.unfoldButtonClick), for: .touchUpInside)
    }
    
    @objc private func unfoldButtonClick(){
        unfoldeAllButton.isHidden = true
        guard let text = descripationLabel.text else {
            return
        }
//        let str = text as NSString
//        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
//        let withinSize = CGSize(width: UIScreen.main.bounds.width - 30, height: CGFloat(MAXFLOAT))
//        let size = str.boundingRect(with: withinSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        
        let labelHeight = getLabelSize(FontSize: 15, text: text)
        let cellHeight = 500 + labelHeight - 75
        descripationLabelHeightCon.constant = labelHeight + 10
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unfoldNote"), object: nil, userInfo: ["row": indexPathRow, "cellHeight": cellHeight, "LabelHeight": labelHeight])
        UIView.animate(withDuration: 0.5) { 
            self.descripationLabel.layoutIfNeeded()
        }
    }
}

extension ShareCell{
    fileprivate func getLabelSize(FontSize: CGFloat, text: String?) -> CGFloat{
        guard text != nil else {
            return 80
        }
        let str = text! as NSString
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: FontSize)]
        let size = str.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: CGFloat(MAXFLOAT)),  options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return size.height
    }
}
//MARK:图片点击的监听

extension ShareCell{
    
    fileprivate func setUpMainImage(){
        mainImageView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.mainImageTap))
        mainImageView.addGestureRecognizer(tapGes)
    }
    
    @objc private func mainImageTap(){
        delegate?.mainImageClick(row: indexPathRow)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedImageNote"), object: nil, userInfo: ["cell": self])
    }
    
    
}

//MARK:转场动画的代理
extension ShareCell: PhotoBrowserPresentedDelegate{
    func getImageView(item: Int, isMain: Bool) -> UIImageView {
        let imageView = UIImageView()
        if isMain {imageView.image = mainImageView.image}
        else{
            let url = URL(string: contents[item + 1].photo_url!)
            imageView.sd_setImage(with: url)
        }
        return imageView
    }
    
    func getStartRect(item: Int, isMain: Bool) -> CGRect {
        if isMain {
            let rect = self.convert(mainImageView.frame, to: UIApplication.shared.keyWindow!)
            return rect
        }
        let cell = picCollectionView.cellForItem(at: IndexPath(item: item, section: 0))
        var rect = picCollectionView.convert(cell!.frame, to: UIApplication.shared.keyWindow!)
        rect.origin.y += 44
        return rect
    }
    
    func getEndRecrt(item: Int, isMain: Bool) -> CGRect {
        let imageView = UIImageView()
        var rect = CGRect()
        let url = isMain ? URL(string: contents[0].photo_url!) : URL(string: contents[item + 1].photo_url!)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"), options: .progressiveDownload, completed: { (image, error, _, _) in
            if error != nil || image == nil {print("无法获取图片尺寸");return; }
            let size = image!.size
            let h = (UIScreen.main.bounds.width / size.width) * size.height
            let y = (UIScreen.main.bounds.height - h) * 0.5
            if y < 0{
                rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: h)
            }else{
                rect = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: h)
            }
        })
        
        return rect
    }
}



//MARK:picCollectionView-DataSource, Delegate
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
    
    //MARK:图片点击的监听
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("选中了\(indexPathRow)的第\(indexPath.row)张照片")
        delegate?.picImageClick(row: indexPathRow, item: indexPath.item)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedImageNote"), object: nil, userInfo: ["cell": self])
    }
    
    
}






