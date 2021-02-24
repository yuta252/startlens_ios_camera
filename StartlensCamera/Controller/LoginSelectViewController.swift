//
//  ViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/24.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit

class LoginSelectViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocale()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        performSegue(withIdentifier: "logIn", sender: nil)
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

