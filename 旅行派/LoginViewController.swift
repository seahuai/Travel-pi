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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func registerButtonClick(_ sender: AnyObject) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if username == "" && password != ""{
            SVProgressHUD.showError(error: "请输入用户名", interval: 1.0)
            return
        }else if username != "" && password == ""{
            SVProgressHUD.showError(error: "请输入密码", interval: 1.0)
            return
        }else if username == "" && password == ""{
            SVProgressHUD.showError(error: "请输入用户名和密码", interval: 1.0)
            return
        }
        
        EMClient.shared().register(withUsername: username, password: password) { (_, error) in
            if error != nil{
                SVProgressHUD.showError(error: error!.errorDescription, interval: 1.5)
            }else{
                SVProgressHUD.showSuccess(info: "注册成功", interval: 1.0)
            }
        }
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
