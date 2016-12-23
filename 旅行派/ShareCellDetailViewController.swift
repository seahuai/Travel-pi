//
//  ShareCellDetailViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/22.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShareCellDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var note: TravelNote?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView(note: note!)
        title = note?.topic
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }

}

extension ShareCellDetailViewController{
    fileprivate func setUpNavigationBar(){
        let shareButton = UIBarButtonItem(title: "分享", style: .plain, target: self, action: #selector(self.shareButtonClick))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func shareButtonClick(){
        let alert = UIAlertController(title: "分享到", message: nil, preferredStyle: .actionSheet)
        let weiboAction = UIAlertAction(title: "微博", style: .default) { (_) in
            print("分享到微博")
        }
        let qqAction = UIAlertAction(title: "QQ", style: .default) { (_) in
            print("分享到QQ")
        }
        let wechatAction = UIAlertAction(title: "微信", style: .default) { (_) in
            print("分享到微信")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(weiboAction)
        alert.addAction(qqAction)
        alert.addAction(wechatAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ShareCellDetailViewController: UIWebViewDelegate{
    fileprivate func setUp(){
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
    }
    
    fileprivate func loadWebView(note: TravelNote){
        let cssUrl = Bundle.main.url(forResource: "index", withExtension: "css")
        let headHtml = "<head><link href=\"\(cssUrl!)\" rel=\"stylesheet\"></head>"
        let topic = "<div id=\"topic\"><h3>\(note.topic!)</h3></div>"
        let user = "<span class=\"user\">\(note._user!.name!)</span>"
        let t = note.made_time == nil ? "时间：未知" : note.made_time!
        let time = "<span class=\"time\">\(t)</span>"
        let subtitle = "<div id=\"subtitle\">\(user)\(time)<div>"
        let des = note._description == nil ? "" : note._description!
        let descripation = "<div id=\"descripation\">\(des)</div>"
        var bodyHtml = "<body>\(topic)\(subtitle)<!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img-->\(descripation)</body>"
        for content in note._contents{
            if let url = content.photo_url{
                var caption = ""
                let img = "<img src=\"\(url)\">"
                if content.caption != nil{ caption = "<div>\(content.caption!)</div>" }
                let image = "<div class=\"image\">\(img)\(caption)</div>"
                if let range = bodyHtml.range(of: "<!--img-->"){
                    bodyHtml.replaceSubrange(range, with: image)
                }
            }
        }
        let html = "<html>\(headHtml)\(bodyHtml)</html>"
//        print(html)
        webView.loadHTMLString(html, baseURL: nil)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
