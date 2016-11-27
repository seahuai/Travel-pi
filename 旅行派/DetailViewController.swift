//
//  DetailViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titlesView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    var destination: Destination?
    fileprivate var titles: [String] = ["经典路线","旅行游记"]
    fileprivate var titlesButton: [UIButton] = [UIButton]()
    fileprivate var preButton: UIButton?
    fileprivate let screenBounds = UIScreen.main.bounds
    
    @IBOutlet weak var backButtonHeightCon: NSLayoutConstraint!
    //子控制器
    fileprivate lazy var tripViewController: TripViewController = TripViewController()
//    fileprivate lazy var listViewController: ListViewController = ListViewController()
    fileprivate lazy var noteViewController: NoteViewController = NoteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        automaticallyAdjustsScrollViewInsets = false
        setUpTitles()
        setUpContentView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        let index = Int(contentScrollView.contentOffset.x / screenBounds.width)
        titlesButtonClick(button: titlesButton[0])
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }

}

extension DetailViewController{
    fileprivate func setUpTitles(){
        let btnWidth: CGFloat = 70
        let btnHeight: CGFloat = 35
        let bottom: CGFloat = 5
        let y: CGFloat = 64 - btnHeight - bottom
        let x: CGFloat = (screenBounds.width - CGFloat(titles.count) * btnWidth) * 0.5
        for i in 0..<titles.count{
            let btn = UIButton()
            btn.frame = CGRect(x: x + CGFloat(i) * btnWidth, y: y, width: btnWidth, height: btnHeight)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.textAlignment = .left
            btn.setTitle(titles[i], for: .normal)
            btn.addTarget(self, action: #selector(self.titlesButtonClick(button:)), for: .touchUpInside)
            btn.tag = i
            if i == 0{
                setTitlesButtonColor(button: btn)
            }
            titlesButton.append(btn)
            titlesView.addSubview(btn)
        }
    }
    
    @objc fileprivate func titlesButtonClick(button: UIButton){
        let tag = button.tag
        setTitlesButtonColor(button: button)
        setCurrentViewController(index: tag)
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(tag) * screenBounds.width, y: 0), animated: true)
    }
    
    fileprivate func setTitlesButtonColor(button: UIButton){
        preButton?.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(globalColor, for: .normal)
        UIView.animate(withDuration: 0.2) { 
            self.preButton?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
        preButton = button
    }
}

extension DetailViewController: UIScrollViewDelegate{
    fileprivate func setUpContentView(){
        contentScrollView.contentSize = CGSize(width: screenBounds.width * CGFloat(titles.count), height: 0)
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        addChildViewController(tripViewController)
//        addChildViewController(listViewController)
        addChildViewController(noteViewController)
        
        setCurrentViewController(index: 0)
    }
    
    fileprivate func setCurrentViewController(index: Int){
        let vc1 = childViewControllers[0] as! TripViewController
        vc1.destination = destination
//        let vc2 = childViewControllers[1] as! ListViewController
//        vc2.destination = destination
        let vc3 = childViewControllers[1] as! NoteViewController
        vc3.destination = destination
        switch index {
        case 0:
            vc1.view.frame = CGRect(x: screenBounds.width * CGFloat(index), y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
            contentScrollView.addSubview(vc1.view)
            if vc1.view.superview != nil{
                return
            }
//        case 1:
//            vc2.view.frame = CGRect(x: screenBounds.width * CGFloat(index), y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
//            contentScrollView.addSubview(vc2.view)
//            if vc2.view.superview != nil{
//                return
//            }
        default:
            vc3.view.frame = CGRect(x: screenBounds.width * CGFloat(index), y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
            contentScrollView.addSubview(vc3.view)
            if vc3.view.superview != nil{
                return
            }
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / screenBounds.width)
        titlesButtonClick(button: titlesButton[index])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
