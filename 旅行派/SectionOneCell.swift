//
//  SectionOneCell.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/10.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
protocol TipCollectionViewDelegate {
    func didSelect(tip: String)
}

class SectionOneCell: UITableViewCell {
    
    var delegate: TipCollectionViewDelegate?
    
    fileprivate let icons: [String] = ["food","bank","bus","gas","wc","hotel","movie","store"]
    fileprivate let tips: [String] = ["餐饮","银行","公交车站","加油站","洗手间","住宿","电影院","便利店"]
    fileprivate lazy var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: FlowLayout())
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SectionOneCell: UICollectionViewDelegate, UICollectionViewDataSource{
    fileprivate func setUp(){
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        
        collectionView.register(UINib(nibName: "IconCell", bundle: nil), forCellWithReuseIdentifier: "IconCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK:dataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        cell.iconAndTip = (icons[indexPath.item], tips[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(tip: tips[indexPath.item])
    }

}

class FlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        let space: CGFloat = 10
        let w = (UIScreen.main.bounds.width - 5 * space) / 4
        let inset: CGFloat = collectionView!.bounds.height - space - 2 * w
        sectionInset = UIEdgeInsets(top: inset / 2, left: 0, bottom: 0, right: 0)
        itemSize = CGSize(width: w, height: w)
        minimumLineSpacing = space
        minimumInteritemSpacing = space
    }
}
