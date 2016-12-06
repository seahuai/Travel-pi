//
//  ChatViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
}

extension ChatViewController: EMChatManagerDelegate{
    
    fileprivate func setUp(){
        EMClient.shared().chatManager.add(self)
        senderId = Account.shared.currentUserID
        senderDisplayName = Account.shared.currentUserID
    }
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        if aMessages != nil{
            EMMesToJSQMes(messages: aMessages!)
        }
    }
    
    fileprivate func refresh(){
        guard let lastMes = conversation?.latestMessage
            else{return}
        conversation?.loadMessages(from: 0, to: lastMes.timestamp + 100, count: 20, completion: { (messages, error) in
            if error == nil && messages != nil{
                self.EMMesToJSQMes(messages: messages!)
            }else{
                print(error!.errorDescription)
            }
        })
    }
    
    fileprivate func EMMesToJSQMes(messages: [Any]){
        for mes in messages{
            let message = mes as! EMMessage
            let text = (message.body as! EMTextMessageBody).text
            let date = Date(timeIntervalSince1970: TimeInterval(message.timestamp/1000))
            let JSQMes = JSQMessage(senderId: message.from, senderDisplayName: message.from, date: date, text: text)
            self.JSQMessages.append(JSQMes!)
        }
//        collectionView.reloadData()
        self.finishReceivingMessage(animated: true)
//        let indexPath = IndexPath(item: JSQMessages.count-1,section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
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
            }else{ print(error?.errorDescription) }
        }
    }
}


