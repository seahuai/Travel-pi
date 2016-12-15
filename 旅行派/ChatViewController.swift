//
//  ChatViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SVProgressHUD
import Photos
import SDWebImage

class ChatViewController: JSQMessagesViewController {

    fileprivate var locationTool = LocationTool()
    fileprivate var location: CLLocation?
    fileprivate var conversation: EMConversation?
    var conversationId: String?{
        didSet{
            title = conversationId
            conversation = EMClient.shared().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
        }
    }
    
    fileprivate var JSQMessages: [JSQMessage] = [JSQMessage]()
    
    fileprivate let incomingBuddle = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.darkGray)
    fileprivate let outgoingBuddle = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    fileprivate let incomingAvater = JSQMessagesAvatarImage(avatarImage: nil, highlightedImage: nil, placeholderImage: UIImage(named: "profile_g"))
    fileprivate let outgoingAvater = JSQMessagesAvatarImage(avatarImage: nil, highlightedImage: nil, placeholderImage: UIImage(named: "profile_y"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if JSQMessages.count == 0{
            refresh()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var error: EMError? = nil
        conversation?.markAllMessages(asRead: &error)
    }
}

extension ChatViewController: EMChatManagerDelegate, LocationDelegate{
    
    func getLocation(location: CLLocation) {
        self.location = location
    }
    
    fileprivate func setUp(){
        locationTool.delegate = self
        locationTool.start()
        EMClient.shared().chatManager.add(self)
        senderId = Account.shared.currentUserID
        senderDisplayName = Account.shared.currentUserID
    }
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        if aMessages != nil{
            EMMesToJSQMes(messages: aMessages!)
            finishReceivingMessage(animated: true)
        }
    }
    
    fileprivate func refresh(){
        guard let lastMes = conversation?.latestMessage
            else{return}
        let UnreadConut = conversation!.unreadMessagesCount
        conversation?.loadMessages(from: 0, to: lastMes.timestamp + 100, count: 20 + UnreadConut, completion: { (messages, error) in
            if error == nil && messages != nil{
                self.EMMesToJSQMes(messages: messages!)
            }else{
                print(error!.errorDescription)
            }
            
            self.finishReceivingMessage()
        })
    }
    
    fileprivate func EMMesToJSQMes(messages: [Any]){
        for mes in messages{
            let message = mes as! EMMessage
            switch message.body {
            case is EMTextMessageBody:
                let text = (message.body as! EMTextMessageBody).text
                let date = Date(timeIntervalSince1970: TimeInterval(message.timestamp/1000))
                let JSQMes = JSQMessage(senderId: message.from, senderDisplayName: message.from, date: date, text: text)
                self.JSQMessages.append(JSQMes!)
            case is EMLocationMessageBody:
                let coor = message.body as! EMLocationMessageBody
                let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
                buildLocationItemMessage(location: location, fromId: message.from)
            case is EMImageMessageBody:
                let body = message.body as! EMImageMessageBody
                let image = UIImage(contentsOfFile: body.thumbnailLocalPath)
                let localImage = UIImage(contentsOfFile: body.localPath)
                if let image = image{
                    buildImageItemMessage(image: image, fromId: message.from)
                }else if let localImage = localImage{
                    buildImageItemMessage(image: localImage, fromId: message.from)
                }else{
                    print(body.remotePath)
                    if let image = imageFrom(urlStr: body.remotePath){
                        buildImageItemMessage(image: image, fromId: message.from)
                    }
                }
            default:
                break
            }
            
        }
    }
    
    fileprivate func imageFrom(urlStr: String?) -> UIImage?{
        if let urlStr = urlStr{
            let url = URL(string: urlStr)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            return image
        }
        return nil
    }
}

extension ChatViewController{
    //MARK:时间戳
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.row % 3 == 0{
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.row % 3 == 0{
            let data = JSQMessages[indexPath.row]
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: data.date)
        }
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JSQMessages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = JSQMessages[indexPath.row]
        return data
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = JSQMessages[indexPath.row]
        switch data.senderId {
        case senderId:
            return outgoingBuddle
        default:
            return incomingBuddle
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let data = JSQMessages[indexPath.row]
        switch data.senderId {
        case senderId:
            return outgoingAvater
        default:
            return incomingAvater
        }
    }
}


extension ChatViewController{
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alertSheet = UIAlertController(title: "发送", message: nil, preferredStyle: .actionSheet)
        let sendPositionAc = UIAlertAction(title: "当前位置", style: .default) { (_) in
            self.locationTool.start()
            self.sendPostionMessage()
            alertSheet.dismiss(animated: true, completion: nil)
        }
        
        let sendImageAc = UIAlertAction(title: "图片", style: .default) { (_) in
           _ = self.zz_presentPhotoVC(1, completeHandler: { (assets) in
                self.sendImageMessage(assets: assets)
            })
        }
        
        let cancelAc = UIAlertAction(title: "取消", style: .cancel) { (_) in
            alertSheet.dismiss(animated: true, completion: nil)
        }
        alertSheet.addAction(sendImageAc)
        alertSheet.addAction(sendPositionAc)
        alertSheet.addAction(cancelAc)
        present(alertSheet, animated: true, completion: nil)
    }



    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let JSQMes = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        JSQMessages.append(JSQMes!)
        sendMessage(text: text, senderId: senderId)
        
    }
    
    fileprivate func sendMessage(text: String?, senderId: String){
        let body = EMTextMessageBody(text: text)
        let EMMes = EMMessage(conversationID: conversationId, from: senderId, to: conversationId, body: body, ext: nil)
        EMClient.shared().chatManager.send(EMMes, progress: nil) { (_, error) in
            if error == nil{
                self.finishSendingMessage(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: error!.errorDescription)
                SVProgressHUD.dismiss(withDelay: 0.8)
            }
        }
    }
    
    fileprivate func sendImageMessage(assets: [PHAsset]){
        for asset in assets{
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, _, _, _) in
                guard data != nil else{return}
                let body = EMImageMessageBody(data: data, displayName: nil)
                let EMMes = EMMessage(conversationID: self.conversationId, from: self.senderId, to: self.conversationId, body: body, ext: nil)
                EMClient.shared().chatManager.send(EMMes, progress: { (progress) in
//                    SVProgressHUD.showProgress(Float(progress/100))
//                    if progress == 100{
//                        SVProgressHUD.dismiss()
//                    }
                    }, completion: { (_, error) in
                        if error == nil{
                            self.buildImageItemMessage(data: data!, fromId: self.senderId)
                            self.finishSendingMessage(animated: true)
                        }else{
                            SVProgressHUD.showError(withStatus: "发送失败")
                            SVProgressHUD.dismiss(withDelay: 0.5)
                        }
                })
            })
        }
    }
    
    fileprivate func sendPostionMessage(){
        
        if location == nil{SVProgressHUD.showError(withStatus: "无法获取位置");SVProgressHUD.dismiss(withDelay: 0.5);return}
        let latitude = Double(location!.coordinate.latitude)
        let lontitude = Double(location!.coordinate.longitude)
        let body = EMLocationMessageBody(latitude: latitude, longitude: lontitude, address: nil)
        let EMMes = EMMessage(conversationID: conversationId, from: senderId, to: conversationId, body: body, ext: nil)
        EMClient.shared().chatManager.send(EMMes, progress: { (_) in
            SVProgressHUD.show()
            }) { (_, error) in
            SVProgressHUD.dismiss()
                if error == nil{
                    self.finishSendingMessage(animated: true)
                    self.buildLocationItemMessage(location: self.location, fromId: self.senderId)
                }else{
                    SVProgressHUD.showError(withStatus: error!.errorDescription)
                    SVProgressHUD.dismiss(withDelay: 0.8)
                }
        }
    }
    
    fileprivate func buildLocationItemMessage(location: CLLocation!,fromId: String){
        let item = JSQLocationMediaItem()
        item.setLocation(location) { 
            self.collectionView.reloadData()
        }
        
        addMediaItem(item: item, fromId: fromId)
    }
    
    fileprivate func buildImageItemMessage(image: UIImage, fromId: String){
        let item = JSQPhotoMediaItem(image: image)
        
        addMediaItem(item: item, fromId: fromId)
    
    }
    
    fileprivate func buildImageItemMessage(data: Data, fromId: String){
        let image = UIImage(data: data)
        let item = JSQPhotoMediaItem(image: image)

        addMediaItem(item: item, fromId: fromId)
    }
    
    
    fileprivate func addMediaItem(item: JSQMediaItem!, fromId: String){
        let JSQMes = JSQMessage(senderId: fromId, senderDisplayName: fromId, date: Date(), media: item)
        JSQMessages.append(JSQMes!)
        self.finishSendingMessage(animated: true)
    }
    
}


