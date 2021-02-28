//
//  ViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/24.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit
import SwiftyJSON


class LoginSelectViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocale()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let isLogIn = UserDefaults.standard.bool(forKey: "isLogIn")
        // Auto login
        if isLogIn {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(identifier: "home") as! HomeViewController
            self.navigationController?.pushViewController(homeView, animated: true)
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(identifier: "logIn") as! LogInViewController
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func setupUI(){
        logInButton.setTitle("logInButtonText".localized, for: .normal)
    }
    
    func setupLocale(){
        let locale = NSLocale.current
        let localeId = locale.identifier
        let array: [String] = localeId.components(separatedBy: "_")
        UserDefaults.standard.set(array[0], forKey: "language")
        UserDefaults.standard.set(array[1], forKey: "country")
    }
}

