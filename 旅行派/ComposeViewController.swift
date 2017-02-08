//
//  ComposeViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/8.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeToolViewBottomCon: NSLayoutConstraint!
    fileprivate lazy var titleView = ComposeTitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var pickPictureViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeholderLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setUpNavigationBar()
        setUpKeyboardNote()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
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
