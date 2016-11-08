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
    fileprivate lazy var descripationLabel: UILabel = UILabel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var labelScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var note: TravelNote?{
        didSet{
            if let note = note{
                titleLabel.text = note.topic
                let height = getLabelSize(FontSize: 14, text: note._description)
                descripationLabel.text = note._description
                descripationLabel.bounds.size.height = height
                descripationLabel.frame.origin = CGPoint(x: 0, y: 0)
                labelScrollView.contentSize = CGSize(width: 0, height: height)
                
                if let urlStr = note._contents[0].photo_url{
                    let url = URL(string: urlStr)
                    backGroundImageView.sd_setImage(with: url, placeholderImage: nil)
                }
                picCollectionView.reloadData()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        setUpLabel()
    }

}

extension AlbumCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func setUpCollectionView(){
        picCollectionView.delegate = self
        picCollectionView.dataSource = self
        picCollectionView.register(UINib(nibName: "AlbumPicCell", bundle: nil), forCellWithReuseIdentifier: "AlbumPicCell")
        picCollectionView.showsHorizontalScrollIndicator = false
        picCollectionView.isPagingEnabled = true
        picCollectionView.collectionViewLayout = collectionViewLayout()
        picCollectionView.backgroundColor = UIColor.clear
    }
    
    func setUpLabel(){
        descripationLabel.font = UIFont.systemFont(ofSize: 14)
        descripationLabel.textColor = UIColor.lightGray
        descripationLabel.numberOfLines = 0
        descripationLabel.bounds.size.width = UIScreen.main.bounds.width - 20
        
        labelScrollView.addSubview(descripationLabel)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = note!._contents.count
        return note!._contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPicCell", for: indexPath) as! AlbumPicCell
        cell.urlStr = note!._contents[indexPath.item].photo_url
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    fileprivate func collectionViewLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds
        layout.itemSize = CGSize(width: screen.width, height: self.bounds.height * 0.40)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }
    
    fileprivate func getLabelSize(FontSize: CGFloat, text: String?) -> CGFloat{
        guard text != nil else {
            return 80
        }
        let str = text! as NSString
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: FontSize)]
        let size = str.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 20, height: CGFloat(MAXFLOAT)),  options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return size.height
    }
}


