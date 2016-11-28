//
//  ShowTripDetailViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/28.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class TripInfoViewController: UIViewController {

    fileprivate let screenBounds = UIScreen.main.bounds
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var closeButton = UIButton()
    
    var indexPath: IndexPath?
    var day: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpScrollView()
        scrollView.contentOffset.x = CGFloat(indexPath!.row - 1) * screenBounds.width
    }
}


extension TripInfoViewController{

    fileprivate func setUp(){
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "back"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.dismissInfo), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-15)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        closeButton.layer.cornerRadius = 20
        closeButton.layer.masksToBounds = true
    }
    
    
    fileprivate func setUpScrollView(){
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: screenBounds.width * CGFloat(day!.activities.count), height: 0)
        for i in 0..<day!.activities.count{
            let activity = day!.activities[i]
            let view = setInfoView(activity: activity, index: i)
            scrollView.addSubview(view)
        }
    }
    
    
    fileprivate func setInfoView(activity: Activity, index: Int) -> UIView{
        let space: CGFloat = 5
        let view = UIView()
        let titleLabel = UILabel()
        let introduceLabel = UILabel()
        let infoX: CGFloat = 20
        let introduceHeight = getLabelSize(FontSize: 15, text: activity.introduce, space: 2 * infoX)
        let height = 3 * space + 40 + introduceHeight
        let infoY = (screenBounds.height - height) * 0.5
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.addSubview(titleLabel)
        view.addSubview(introduceLabel)
        view.frame = CGRect(x: screenBounds.width * CGFloat(index) + infoX, y: infoY, width: screenBounds.width - 2 * infoX, height: height)
        view.backgroundColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = activity.topic
        titleLabel.textColor = globalColor
        introduceLabel.font = UIFont.systemFont(ofSize: 14)
        introduceLabel.text = activity.introduce
        introduceLabel.numberOfLines = 0
        introduceLabel.textColor = UIColor.darkGray
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(space)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(40)
        }
        
        introduceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(space)
            make.left.equalTo(view.snp.left).offset(space)
            make.right.equalTo(view.snp.right).offset(-space)
            make.height.equalTo(introduceHeight)
        }
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.dismissInfo))
        view.addGestureRecognizer(tapGes)
        return view
    }
    
    @objc private func dismissInfo(){
        dismiss(animated: false, completion: nil)
    }
    
    fileprivate func getLabelSize(FontSize: CGFloat, text: String?, space: CGFloat) -> CGFloat{
        guard text != nil else {
            return 0
        }
        let str = text! as NSString
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: FontSize)]
        let size = str.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - space, height: CGFloat(MAXFLOAT)),  options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return size.height
    }
}
