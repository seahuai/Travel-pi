//
//  ComposeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/8.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD
protocol ComposeDelegate {
    func compose(imageUrls: [URL], content: String?)
}
class ComposeViewController: UIViewController {

    var delegate: ComposeDelegate?
    
    fileprivate var chosenImages: [UIImage] = [UIImage]()
    @IBOutlet weak var composeToolViewBottomCon: NSLayoutConstraint!
    fileprivate lazy var titleView = ComposeTitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pickImageCollectionView: PickImageCollectionView!
    @IBOutlet weak var pickPictureViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeholderLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setUpNavigationBar()
        setUpKeyboardNote()
        setUpPickImageNote()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pickPictureViewHeight.constant == 0{
            textView.becomeFirstResponder()
        }
    }
    
  

}

extension ComposeViewController{
    fileprivate func setUpNavigationBar(){
        let closeButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.close))
        let composeButton = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(self.compose))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = composeButton
        navigationItem.titleView = titleView
        titleView.sizeToFit()
    }
    
    @objc private func close(){
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func compose(){
        //模拟发布
        let imgUrls = saveImages(images: chosenImages)
        delegate?.compose(imageUrls: imgUrls, content: textView.text)
        close()
    }
    
    fileprivate func saveImages(images: [UIImage]) -> [URL]{
        
        var imageUrls: [URL] = [URL]()
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let createPath = mainPath + "/Images"
        if !FileManager.default.fileExists(atPath: createPath){
            if ((try? FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)) == nil){
                return imageUrls
            }
        }
        for i in 0 ..< images.count{
            let image = images[i]
            let savePath = mainPath + "/Images" + "/pic_\(i)_\(Date())"
            let url = URL(fileURLWithPath: savePath)
            print(url)
            do{
                try UIImagePNGRepresentation(image)?.write(to: url)
                imageUrls.append(url)
            }
            catch{
                print("存取图片失败")
            }
        }
        return imageUrls
    }
}

extension ComposeViewController: UITextViewDelegate{
    fileprivate func setUp(){
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLable.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLable.isHidden = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}

//MARK:键盘
extension ComposeViewController{
    fileprivate func setUpKeyboardNote(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeToolViewPosition(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func changeToolViewPosition(note: NSNotification){
        let interval = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = UIScreen.main.bounds.height - endFrame.origin.y
        composeToolViewBottomCon.constant = y
        UIView.animate(withDuration: interval, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: 工具栏
    @IBAction func chooseImageButtonClick(_ sender: AnyObject) {
        if pickPictureViewHeight.constant == 0{
        textView.resignFirstResponder()
        pickPictureViewHeight.constant = UIScreen.main.bounds.height * 0.6
        }else{
            pickPictureViewHeight.constant = 0
            textView.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    @IBAction func changeKeyboradButtonClick(_ sender: AnyObject) {
        pickPictureViewHeight.constant = 0
        textView.resignFirstResponder()
        textView.inputView = nil
        textView.becomeFirstResponder()
    }
}
//MARK:选取图片
extension ComposeViewController{
    fileprivate func setUpPickImageNote(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteImage(note:)), name: NSNotification.Name(rawValue: "DeleteImageNote"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseImage), name: NSNotification.Name(rawValue: "ChooseImageNote"), object: nil)
    }
    
    @objc private func chooseImage(){
        _ = zz_presentPhotoVC(9) { (assets) in
            for asset in assets{
                self.handleImage(asset: asset)
            }
        }
    }
    
    fileprivate func handleImage(asset: PHAsset){
        PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, _, _, _) in
            guard data != nil
                else {return}
            if let image = UIImage(data: data!){
                self.chosenImages.append(image)
            }
            self.pickImageCollectionView.images = self.chosenImages
        })
    }
    
    
    @objc private func deleteImage(note: NSNotification){
        let image = note.userInfo?["image"] as! UIImage
        if let i = chosenImages.index(of: image) {
            chosenImages.remove(at: i)
        }
        pickImageCollectionView.images = chosenImages
    }
    
}
