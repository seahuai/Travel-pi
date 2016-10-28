//
//  DestinationCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class DestinationCell: UITableViewCell {
    
    var destinations: [Destination] = [Destination]()
    var cellId: String = ""
    
    @IBOutlet weak var findMoreButton: UIButton!
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollcetionView()
        setUpLayout()
//        findMoreButton.layer.masksToBounds
    }
   
}


extension DestinationCell{

    fileprivate func setUpCollcetionView(){
        picCollectionView.dataSource = self
        picCollectionView.delegate = self
        
        picCollectionView.register(UINib(nibName: "picCollectionCell", bundle: nil), forCellWithReuseIdentifier: "picCollectionCell")
        
    }
    
    fileprivate func setUpLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 7
        let items: CGFloat = 3
        let itemW = (UIScreen.main.bounds.width - 4 * space) / items
        let itemH = itemW
        
        layout.minimumLineSpacing = space
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        
        picCollectionView.showsHorizontalScrollIndicator = false
        picCollectionView.collectionViewLayout = layout
    }
}

extension DestinationCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picCollectionView.dequeueReusableCell(withReuseIdentifier: "picCollectionCell", for: indexPath) as! picCollectionCell
        cell.destination = destinations[indexPath.item]
        return cell
    }
    
    
    
}

extension DestinationCell: UICollectionViewDelegate{
    
    @IBAction func findMoreButtonClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicCollectionViewScrollNote), object: nil, userInfo: ["cellId": cellId])
    }
    
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contensizeX = picCollectionView.contentSize.width
        if picCollectionView.contentOffset.x > (contensizeX + 50) / 2{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicCollectionViewScrollNote), object: nil, userInfo: ["cellId": cellId])
            //通知HomeVC
        }
    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
    
    
    
}
