//
//  AlubmDetailViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/6.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopCon: NSLayoutConstraint!
    fileprivate var notes: [TravelNote] = [TravelNote]()
    var album: TravelAlbum?{
        didSet{
            notes = album!.travelNotes
        }
    }
    var index: Int = 0{
        didSet{
            indexPath = IndexPath(item: index, section: 0)
        }
    }
    fileprivate var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        collectionView.scrollToItem(at: indexPath!, at: .left, animated: true)
    }
}

extension AlbumDetailViewController{
    
    fileprivate func setUp(){
        self.view.layoutIfNeeded()
        navigationItem.title = "每周精选"
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectioviewLayout()
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
        let leftButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.closeButtonClick))
        navigationItem.leftBarButtonItem = leftButton
        
        sentenceLabel.text = album?.summary
    }
    
    @objc private func closeButtonClick(){
        dismiss(animated: true) {}
    }
    
    fileprivate func collectioviewLayout() -> UICollectionViewFlowLayout{
        
        let screen = UIScreen.main.bounds
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screen.width, height: screen.height - collectionViewTopCon.constant)
//        layout.itemSize = collectionView.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    

}

extension AlbumDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(notes.count)
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.note = notes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        navigationItem.title = "每周精选（\(indexPath.row + 1)\\\(notes.count)）"
    }
    
    
}



