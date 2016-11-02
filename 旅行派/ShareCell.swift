//
//  ShareCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/29.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol ShareCellImageDelegate {
    func mainImageClick(row: Int)
    func picImageClick(row: Int, item: Int)
}

class ShareCell: UITableViewCell {
    
    var indexPathRow: Int = 0
    var delegate: ShareCellImageDelegate?
    
    
    @IBOutlet weak var unfoldeAllButton: UIButton!
    @IBOutlet weak var readAllButton: UIButton!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descripationLabel: UILabel!
    
    @IBOutlet weak var picCollectionViewHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var descripationLabelHeightCon: NSLayoutConstraint!
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
                mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
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
        
        let labelHeight = getLabelSize(FontSize: 14, text: text)
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
    }
    
    
}






