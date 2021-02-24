//
//  LogInViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/24.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class LogInViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passWordField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    @IBOutlet weak var signinButtonText: UIButton!
    
    var authEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passWordField.delegate = self
        setupUI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        // Validation
        guard let emailAddress = emailField.text, !emailAddress.isEmpty else{
           passWordMessage.text = "emailValidMessage".localized
           passWordMessage.textColor = ThemeColor.errorString
           return
        }
        
        guard let passWord = passWordField.text, !passWord.isEmpty else{
            passWordMessage.text = "passValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        self.authEmail = emailAddress
        
        let parameters = ["user": ["email": emailAddress, "password": passWord]]
        
        AF.request(Constants.baseURL + Constants.tokenURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print("response: \(response)")
            
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                print("json: \(json)")
                if let token = json["token"].string {
                    print("login")
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(true, forKey: "isLogIn")
                    self.performSegue(withIdentifier: "home", sender: nil)
                } else {
                    print("error: cannot parse json")
                    DispatchQueue.main.async {
                        self.passWordMessage.text = "authValidFail".localized
                        self.passWordMessage.textColor = ThemeColor.errorString
                    }
                }
            case .failure(let error):
                print("error: \(error)")
                DispatchQueue.main.async {
                    self.passWordMessage.text = "authValidFail".localized
                    self.passWordMessage.textColor = ThemeColor.errorString
                }
            }
        }
        
    }

    func setupUI() {
        emailField.placeholder = "emailInputPlace".localized
        passWordField.placeholder = "passwordInputPlace".localized
        passWordMessage.text = "signupErrorMessage".localized
        signinButtonText.setTitle("logInButtonText".localized, for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailaddress = emailField.text, !emailaddress.contains("@") {
            passWordMessage.text = "emailValidMessage2"
            passWordMessage.textColor = ThemeColor.errorString
        }
    }
}
