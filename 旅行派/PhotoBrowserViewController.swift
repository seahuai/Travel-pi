//
//  PhotoBrowserViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class PhotoBrowserViewController: UIViewController {
    
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    //MARK:模型
    var contents: [Content] = [Content](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var shareButton = UIButton()
    fileprivate lazy var closeButton = UIButton()
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpButton()
        setUpButtonTarget()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollToItem(at: selectedIndex , at: .left, animated: false)
    }

}

extension PhotoBrowserViewController{
    
    fileprivate func setUp(){
//        self.view.layoutIfNeeded()
        view.addSubview(collectionView)
        view.addSubview(shareButton)
        view.addSubview(closeButton)
        view.frame.size.width += 20
        
        collectionView.frame = view.bounds
        collectionView.isPagingEnabled = true
    }
    
    
    fileprivate func setUpButton(){
        
        shareButton.titleLabel?.textAlignment = .center
        shareButton.titleLabel?.textColor = UIColor.darkGray
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        shareButton.backgroundColor = UIColor.clear
        
        closeButton.setImage(UIImage(named: "close_white"), for: .normal)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(25)
            make.left.equalTo(view.snp.left).offset(20)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        shareButton.setTitle("...", for: .normal)
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(25)
            make.right.equalTo(view.snp.right).offset(-40)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
    }
}


extension PhotoBrowserViewController: PhotoCellImageDelegate{
    fileprivate func setUpButtonTarget(){
        shareButton.addTarget(self, action: #selector(self.shareButtonClick), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.closeButtonClick), for: .touchUpInside)
    }
    
    
    @objc private func shareButtonClick(){
        let cell = collectionView.visibleCells.first as! PhotoCell
        let caption = cell.content?.caption ?? "分享图片"
        UMSocialUIManager.setPreDefinePlatforms([0,1,2,4])
        if let image = cell.imageView.image{
            UMSocialUIManager.showShareMenuViewInWindow { (type, _) in
                let imgObj = UMShareImageObject()
                imgObj.shareImage = image
                let mesObj = UMSocialMessageObject()
                mesObj.text = caption
                mesObj.shareObject = imgObj
                UMSocialManager.default().share(to: type, messageObject: mesObj, currentViewController: nil, completion: { (_, error) in
                    if error != nil{ print("分享失败",error) }
                })
            }
        }
    }
    
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage?, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error == nil{
            SVProgressHUD.showSuccess(info: "已保存到相册", interval: 1.0)
        }else{
            SVProgressHUD.showError(error: "保存失败", interval: 1.0)
        }
    }
    
    @objc private func closeButtonClick(){
        photoCellImageClick()
    }
    //MARK:PhotoCell的代理方法
    func photoCellImageClick() {
        dismiss(animated: true) {}
    }
    
    func longPress(image: UIImage, caption: String) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let save = UIAlertAction(title: "保存图片", style: .default) { (_) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .default) { (_) in
            ac.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(save)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension PhotoBrowserViewController: UICollectionViewDataSource{
    
    fileprivate func setUpCollectionView(){
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.content = contents[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension PhotoBrowserViewController: PhotoBrowserDismissDelegate{
    
    func getCellIndexPath() -> IndexPath{
        let cell = collectionView.visibleCells.first
        let indexPath = collectionView.indexPath(for: cell!)
        return indexPath!
    }
    
    func getImageView() -> UIImageView {
        let cell = collectionView.visibleCells.first as! PhotoCell
        let imageView  = UIImageView()
        imageView.image = cell.imageView.image
        return imageView
    }
}

class layout: UICollectionViewFlowLayout{
    
    override func prepare() {
        
        itemSize = collectionView!.frame.size
        
        scrollDirection = .horizontal
        minimumLineSpacing = 0
    }
    
    
}
