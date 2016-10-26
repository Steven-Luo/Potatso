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
    
    var backgroundImage: UIImageView!
    var userNameTextField: UITextField!
    var passwordTextField: UITextField!
    var loginRect: UIImageView!
    var loginButton: UIButton!
    var linkLabel: UILabel!
    let underlineAttribute =  [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    var underlineAttributedString: NSAttributedString!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    let textRegister = "Click Me to Register".localized()
    let textFoggetPassword = "Forget Password".localized()
    var link: String!
    
    var isLoginFailed = false
    
    var firstEnter = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        let viewBounds = view.bounds
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: viewBounds.width, height: viewBounds.height))
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
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
        userNameTextField.keyboardType = .EmailAddress
        userNameTextField.addTarget(self, action: #selector(restoreLoginState(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        loginRect.addSubview(userNameTextField)
        
        let userNamePlaceholder = UILabel(frame: CGRect(x: 6, y: 6, width: 100, height: 10))
        userNamePlaceholder.text = "E-MAIL"
        userNamePlaceholder.font = UIFont.systemFontOfSize(10)
        userNamePlaceholder.textColor = UIColor.lightGray
        userNameTextField.addSubview(userNamePlaceholder)
        
        passwordTextField = UITextField(frame: CGRect(x: 45, y: 275, width: loginRect.bounds.width - 90, height: 50))
        passwordTextField.borderStyle = UITextBorderStyle.RoundedRect
        passwordTextField.secureTextEntry = true
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(restoreLoginState(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        loginRect.addSubview(passwordTextField)
        loginRect.userInteractionEnabled = true
        
        let passwordPlaceholder = UILabel(frame: CGRect(x: 6, y: 6, width: 100, height: 10))
        passwordPlaceholder.text = "PASSWORD"
        passwordPlaceholder.font = UIFont.systemFontOfSize(10)
        passwordPlaceholder.textColor = UIColor.lightGray
        passwordTextField.addSubview(passwordPlaceholder)
        
        loginButton = UIButton(frame: CGRect(x: 45, y: 340, width: loginRect.bounds.width - 90, height: 45))
        loginButton.setTitle("Login".localized(), forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setBackgroundImage(UIImage(named: "login_button_bg"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        spinner.frame = CGRect(x: 10, y: 45/2.0 - 10, width: 20, height: 20)
        loginButton.addSubview(spinner)
        loginRect.addSubview(loginButton)
        
        linkLabel = UILabel(frame: CGRect(x: loginRect.bounds.width/2.0 - 90, y: 410, width: 180, height: 30))
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
    
    //    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    //        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    //        backgroundImage.image = UIImage(named: "background")
    //        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
    //            self.loginRect.frame = CGRect(x: self.view.bounds.width / 2.0 - 160, y: self.view.bounds.height / 2.0 - 220, width: 320, height: 440)
    //        }, completion: nil)
    //    }
    
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
    
    func showError(msg: String) {
        self.spinner.stopAnimating()
        self.showTextHUD(msg, dismissAfterDelay: 3.0)
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
    
    func usernameOrPasswordWrong(msg: String = "Usernane or Password Wrong".localized()) {
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginButton.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.loginButton.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { _ in
                UIView.transitionWithView(self.loginButton, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                    self.loginButton.setBackgroundImage(UIImage(named: "error_button_bg"), forState: .Normal)
                    self.loginButton.setTitle(msg, forState: UIControlState.Normal)
                    
                    self.spinner.stopAnimating()
                    self.isLoginFailed = true
                    
                    self.switchLink(isRegister: false)
                    }, completion: nil)
        })
    }
    
    func doLogin() {
        spinner.startAnimating()
        
        guard let username = userNameTextField.text , password = passwordTextField.text
            where username != "" && password != "" else{
                usernameOrPasswordWrong("Usernane or Password Empty".localized())
                return
        }
        
        Alamofire.request(.POST, AbestProxyAPI.sharedInstance.ACCESS_TOKEN_API,
            parameters: ["email":username, "passwd":password, "remember_me":"week"],
            encoding: ParameterEncoding.URLEncodedInURL,
            headers: nil).responseJSON { response in
                print("login response: \(response)")
                
                if response.result.isSuccess {
                    let result =  JSON(response.result.value!)
                    print("access token: \(result)")
                    
                    guard let resultCode = result["ret"].int
                        where resultCode == 1 else {
                            if result["ret"].intValue == 0 {
                                self.usernameOrPasswordWrong()
                            } else {
                                self.showError(APIAccessResult.ServerInternalError.description)
                            }
                            return
                    }
                    
                    let token = result["data"]["token"].stringValue
                    let userId = result["data"]["user_id"].intValue
                    
                    UserService.sharedInstance.saveToken(token, userId: userId)
                    UserService.sharedInstance.save(username: username, password: password)
                    
                    UserService.sharedInstance.fetchTrafficUsage()
                    
                    Alamofire.request(.GET, AbestProxyAPI.sharedInstance.PROXY_LIST_API + String(userId), parameters: ["access_token": token],
                        encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON(completionHandler: { (response) in
                            if response.result.isFailure {
                                self.showError(APIAccessResult.NetworkUnreachable.description)
                            } else {
                                print("proxy list: \(response)")
                                
                                let result = JSON(response.result.value!)
                                guard let resultCode = result["ret"].int where resultCode == 1 else {
                                    self.showError(APIAccessResult.ServerInternalError.description)
                                    return
                                }
                                
                                let proxyList: [JSON]? = result["data"].array
                                ProxyService.sharedInstance.addAbestProxies(proxyList!)
                                
                                UserService.sharedInstance.getToken()
                                
                                self.spinner.stopAnimating()
                                let proxyViewController = UIManager.sharedInstance!.getMainViewController()
                                self.presentViewController(proxyViewController, animated: true, completion: nil)
                            }
                        })
                } else {
                    self.showError(APIAccessResult.NetworkUnreachable.description)
                }
        }
    }
    
    func originalLoginButton() {
        self.loginButton.setBackgroundImage(UIImage(named: "login_button_bg"), forState: .Normal)
        self.loginButton.setTitle("Login".localized(), forState: UIControlState.Normal)
    }
    
    func restoreLoginState(sender: AnyObject) {
        self.switchLink(isRegister: true)
        originalLoginButton()
        isLoginFailed = false
    }
    
    func loginButtonTapped(sender: AnyObject) {
        if(isLoginFailed) {
            /// TODO replace the block with a function
            self.switchLink(isRegister: true)
            UIView.transitionWithView(self.loginButton, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.originalLoginButton()
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
