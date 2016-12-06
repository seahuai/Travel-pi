//
//  LoginViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    @IBAction func loginButtonClick(_ sender: AnyObject) {
        
        SVProgressHUD.show(withStatus: "登录中")
        EMClient.shared().login(withUsername: usernameTextField.text, password: passwordTextField.text) { (_, error) in
            if error == nil{
                SVProgressHUD.showSuccess(withStatus: "登陆成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSussess"), object: nil, userInfo: nil)
                EMClient.shared().options.isAutoLogin = self.autoLoginButton.isSelected
                SVProgressHUD.dismiss(withDelay: 0.5)
                EMisLogin = true
                self.close()
            }else{
                SVProgressHUD.showError(withStatus: error!.errorDescription)
                SVProgressHUD.dismiss(withDelay: 1.0)
                EMisLogin = false
            }
        }
    }
    @IBAction func autoLoginButtonClick(_ sender: AnyObject) {
        autoLoginButton.isSelected = !autoLoginButton.isSelected
    }
    
}

extension LoginViewController{
    fileprivate func setUp(){
        let leftItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc fileprivate func close(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        dismiss(animated: true) {}
    }
}
