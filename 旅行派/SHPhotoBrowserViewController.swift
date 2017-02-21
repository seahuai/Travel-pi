//
//  SHPhotoBrowserViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/9.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD
class SHPhotoBrowserViewController: UIViewController {

    var imgUrls: [URL] = [URL]()
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SHCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(imgUrls: [URL], indexPath: IndexPath){
        super.init(nibName: nil, bundle: nil)
        self.imgUrls = imgUrls
        
        setUpCollectionView()
        setUpNavigationBar()
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SHPhotoBrowserViewController{
    fileprivate func setUpNavigationBar(){
        title = "图片"
    }
}

extension SHPhotoBrowserViewController: UICollectionViewDataSource{
    fileprivate func setUpCollectionView(){
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.frame = UIScreen.main.bounds
        collectionView.dataSource = self
        collectionView.register(SHPhotoCell.self, forCellWithReuseIdentifier: "SHPhotoCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SHPhotoCell", for: indexPath) as! SHPhotoCell
        cell.url = imgUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension SHPhotoBrowserViewController: HandleGestureDelegate{
    func longPress(image: UIImage) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "保存到相册", style: .default) { (_) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            alert.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tap(){
        print("点击")
        var y: CGFloat = -64
        if navigationController!.navigationBar.frame.origin.y == -64{
            y = 20
        }
        UIView.animate(withDuration: 0.5) { 
            self.navigationController?.navigationBar.frame.origin.y = y
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

class SHCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}


