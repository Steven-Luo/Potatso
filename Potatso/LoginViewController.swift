//
//  LoginViewController.swift
//  Potatso
//
//  Created by luogang on 16/10/9.
//  Copyright © 2016年 GudaTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var userNameTextField: UITextField!
    var passwordTextField: UITextField!
    var loginRect: UIImageView!
    var loginButton: UIButton!
    var linkLabel: UILabel!
    let underlineAttribute =  [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    var underlineAttributedString: NSAttributedString!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    let textRegister = "点我注册哦"
    let textFoggetPassword = "忘记密码？"
    var link: String!
    
    var uiManager: UIManager?
    
    var isLoginFailed = false
    
    var firstEnter = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        let viewBounds = view.bounds
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: viewBounds.width, height: viewBounds.height))
        backgroundImage.image = UIImage(named: "background")
        self.view.addSubview(backgroundImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //blurView.alpha = 0.2
        backgroundImage.addSubview(blurView)
        
        loginRect = UIImageView(frame: CGRect(x: 23, y: -440, width: 320, height: 440))
        loginRect.image = UIImage(named: "login_rect")
        loginRect.center = self.view.center
        self.view.addSubview(loginRect)
        
        let appLogoImageView = UIImageView(image: UIImage(named: "myApp"))
        appLogoImageView.frame = CGRect(x: loginRect.bounds.width/2.0 - 35, y: 90, width: 70, height: 65)
        loginRect.addSubview(appLogoImageView)
        
        let brandLabel = UILabel(frame: CGRect(x: loginRect.bounds.width/2.0 - 100, y: 160, width: 200, height: 30))
        brandLabel.text = "abest proxy"
        brandLabel.textAlignment = NSTextAlignment.Center
        brandLabel.font = UIFont.systemFontOfSize(20)
        brandLabel.textColor = UIColor.gray
        loginRect.addSubview(brandLabel)
        
        userNameTextField = UITextField(frame: CGRect(x: 45, y: 210, width: loginRect.bounds.width - 90, height: 50))
        userNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        userNameTextField.delegate = self
        userNameTextField.text = "lifeng1519@gmail.com"
        loginRect.addSubview(userNameTextField)
        
        let userNamePlaceholder = UILabel(frame: CGRect(x: 6, y: 6, width: 100, height: 10))
        userNamePlaceholder.text = "USERNAME"
        userNamePlaceholder.font = UIFont.systemFontOfSize(10)
        userNamePlaceholder.textColor = UIColor.lightGray
        userNameTextField.addSubview(userNamePlaceholder)
        
        passwordTextField = UITextField(frame: CGRect(x: 45, y: 275, width: loginRect.bounds.width - 90, height: 50))
        passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
        passwordTextField.secureTextEntry = true
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        passwordTextField.delegate = self
        passwordTextField.text = "gudatech"
        loginRect.addSubview(passwordTextField)
        loginRect.userInteractionEnabled = true
        
        let passwordPlaceholder = UILabel(frame: CGRect(x: 6, y: 6, width: 100, height: 10))
        passwordPlaceholder.text = "PASSWORD"
        passwordPlaceholder.font = UIFont.systemFontOfSize(10)
        passwordPlaceholder.textColor = UIColor.lightGray
        passwordTextField.addSubview(passwordPlaceholder)
        
        loginButton = UIButton(frame: CGRect(x: 45, y: 340, width: loginRect.bounds.width - 90, height: 45))
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setBackgroundImage(UIImage(named: "login_button_bg"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        spinner.frame = CGRect(x: 10, y: 45/2.0 - 10, width: 20, height: 20)
        loginButton.addSubview(spinner)
        loginRect.addSubview(loginButton)
        
        linkLabel = UILabel(frame: CGRect(x: loginRect.bounds.width/2.0 - 45, y: 410, width: 90, height: 30))
        linkLabel.text = textRegister
        linkLabel.font = UIFont.systemFontOfSize(16)
        linkLabel.textColor = UIColor.white
        linkLabel.textAlignment = NSTextAlignment.Center
        
        let labelTapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(forggetPasswordTapped(_:)))
        linkLabel.addGestureRecognizer(labelTapGestureRecongnizer)
        linkLabel.userInteractionEnabled = true
        
        underlineAttributedString = NSAttributedString(string: textRegister, attributes: underlineAttribute)
        linkLabel.attributedText = underlineAttributedString
        
        link = "http://www.abest.me/auth/register"
        loginRect.addSubview(linkLabel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loginRect.frame = CGRect(x: self.view.bounds.width / 2.0 - 160, y: -440, width: 320, height: 440)
        
        if firstEnter {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginRect.frame = CGRect(x: self.view.bounds.width / 2.0 - 160, y: self.view.bounds.height / 2.0 - 220, width: 320, height: 440)
                }, completion: nil)
        } else {
            self.loginRect.frame = CGRect(x: self.view.bounds.width / 2.0 - 160, y: self.view.bounds.height / 2.0 - 220, width: 320, height: 440)
        }
        firstEnter = false
    }
    
    func forggetPasswordTapped(sender: UITapGestureRecognizer) {
        let vc = BaseSafariViewController(URL: NSURL(string: link)!, entersReaderIfAvailable: false)
        //vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func showAlert(msg: String) {
        let alertController = UIAlertController(title: "发生错误啦！", message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func switchLink(isRegister isRegister: Bool) {
        if isRegister {
            linkLabel.text = textRegister
            underlineAttributedString = NSAttributedString(string: textRegister, attributes: underlineAttribute)
            link = "http://www.abest.me/auth/register"
        } else {
            linkLabel.text = textFoggetPassword
            underlineAttributedString = NSAttributedString(string: textFoggetPassword, attributes: underlineAttribute)
            link = "http://abest.me/password/reset"
        }
        linkLabel.attributedText = underlineAttributedString
    }
    
    func usernameOrPasswordWrong() {
        showAlert("用户名或密码错误！")
        
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginButton.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginButton.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { _ in
                UIView.transitionWithView(self.loginButton, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                    self.loginButton.setBackgroundImage(UIImage(named: "error_button_bg"), forState: .Normal)
                    self.loginButton.setTitle("用户名或密码错误！", forState: UIControlState.Normal)
                    
                    self.spinner.stopAnimating()
                    self.isLoginFailed = true
                    
                    self.switchLink(isRegister: false)
                    }, completion: nil)
        })
    }
    
    func doLogin() {
        spinner.startAnimating()
        
        guard let username = userNameTextField.text , password = passwordTextField.text else{
            showAlert("用户名或密码为空！")
            return
        }
        
        Alamofire.request(.POST, "http://dev.abest.me/api/token", parameters: ["email":username, "passwd":password, "remember_me":"week"], encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { response in
            if response.result.isFailure {
                self.showAlert("网络连接错误，请检查网络连接TODO！")
            } else {
                let result =  JSON(response.result.value!)
                guard let resultCode = result["ret"].int where resultCode == 1 else {
                    if result["ret"].intValue == 0 {
                        self.usernameOrPasswordWrong()
                    } else {
                        self.showAlert("服务器内部错误，请联系support@abest.me！")
                    }
                    return
                }
                /*{
                 "ret": 1,
                 "msg": "ok",
                 "data": {
                 "token": "hdAzSxPBzeuegui2O3buOllec9OxjnYRQrmV4f0a5jWtdFCrcv3v1a5PixFV2N1g",
                 "user_id": 5
                 }
                 }*/
                /*{
                 "ret": 0,
                 "msg": "401 邮箱或者密码错误"
                 }*/
                print(result["data"]["token"].string)
                let token = result["data"]["token"].stringValue
                Alamofire.request(.GET, "http://dev.abest.me/api/ss/5", parameters: ["access_token": token], encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON(completionHandler: { (response) in
                    if response.result.isFailure {
                        self.showAlert("网络连接错误，请检查网络连接TODO！")
                    } else {
                        print(response)
                        let result = JSON(response.result.value!)
                        guard let resultCode = result["ret"].int where resultCode == 1 else {
                            self.showAlert("服务器内部错误，请联系support@abest.me！")
                            return
                        }
                        let proxyList: [JSON]? = result["data"].array
                        print(proxyList)
                        ProxyStoreService.addProxies(proxyList!)
                        self.spinner.stopAnimating()
                        //                        let proxyViewController = ProxyViewController()
                        let proxyViewController = self.uiManager?.getMainViewController()
                        //                    proxyViewController.proxyDatas = proxyList
                        //                        self.uiManager?.showMainViewController()
                        //let proxyViewController = self.uiManager?.makeRootViewController()
                        self.presentViewController(proxyViewController!, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if(isLoginFailed) {
            self.switchLink(isRegister: true)
            UIView.transitionWithView(self.loginButton, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.loginButton.setBackgroundImage(UIImage(named: "login_button_bg"), forState: .Normal)
                self.loginButton.setTitle("登录", forState: UIControlState.Normal)
                }, completion: nil)
            isLoginFailed = false
        } else {
            spinner.startAnimating()
            doLogin()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }*/
}
