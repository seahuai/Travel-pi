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
        let closeButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.closeButtonClick))
        let shareButton = UIBarButtonItem(title: "分享", style: .plain, target: self, action: #selector(self.shareButtonClick))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeButtonClick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func shareButtonClick(){
        let alert = UIAlertController(title: "分享到", message: nil, preferredStyle: .actionSheet)
        let weiboAction = UIAlertAction(title: "微博", style: .default) { (_) in
            self.shareImageTo(platform: .sina)
        }
        let qqAction = UIAlertAction(title: "QQ", style: .default) { (_) in
            self.shareImageTo(platform: .QQ)
        }
        let wechatTLAction = UIAlertAction(title: "微信朋友圈", style: .default) { (_) in
            self.shareImageTo(platform: .wechatTimeLine)
        }
        
        let wechatFAction = UIAlertAction(title: "微信好友", style: .default) { (_) in
            self.shareImageTo(platform: .wechatSession)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(weiboAction)
        alert.addAction(qqAction)
        alert.addAction(wechatTLAction)
        alert.addAction(wechatFAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func shareImageTo(platform: UMSocialPlatformType){
        let object = UMShareImageObject()
        object.shareImage = self.note?._contents[0].photo_url
        object.thumbImage = self.note?._contents[0].photo_url
        let mesObject = UMSocialMessageObject()
        mesObject.shareObject = object
        mesObject.text = self.note?.description
        mesObject.title = self.note?.topic
        UMSocialManager.default().share(to: platform, messageObject: mesObject, currentViewController: nil, completion: { (_, error) in
            if error != nil{
                SVProgressHUD.showError(error: "分享失败", interval: 1.0)
            }else{
                SVProgressHUD.showSuccess(info: "分享成功", interval: 1.0)
            }
        })
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
        let jsUrl = Bundle.main.url(forResource: "index", withExtension: "js")
        let script = "<script src=\"\(jsUrl!)\"></script>"
        
        let topic = "<div id=\"topic\"><h3>\(note.topic!)</h3></div>"
        let user = "<span class=\"user\">\(note._user!.name!)</span>"
        let t = note.made_time == nil ? "时间：未知" : note.made_time!
        let time = "<span class=\"time\">\(t)</span>"
        let subtitle = "<div id=\"subtitle\">\(user)\(time)<div>"
        let des = note._description == nil ? "" : note._description!
        let descripation = "<div id=\"descripation\">\(des)</div>"
        
        var bodyHtml = "<body>\(topic)\(subtitle)<!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img--><!--img-->\(descripation)\(script)</body>"
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
//        let requestString = request.url?.absoluteString
//        print(requestString)
        return true
    }
}
