//
//  NaviViewController.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/13.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class NaviViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    fileprivate var request: URLRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(request!)
        setUpNavigationBar()
    }
    
    init(url: URL){
        super.init(nibName: nil, bundle: nil)
        request = URLRequest(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    fileprivate func setUpNavigationBar(){
//        let close = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.close))
//        navigationItem.rightBarButtonItem = close
        title = "导航"
    }
    
//    @objc private func close(){
//        dismiss(animated: true, completion: nil)
//    }

}
