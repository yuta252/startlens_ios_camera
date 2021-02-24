//
//  StringExtension.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/24.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

extension String{
    var localized: String{
        var lang: String?
        
        if let language = UserDefaults.standard.string(forKey: "language"){
            lang = language
        }else{
            lang = "en"
        }
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) else {
           return NSLocalizedString(self, comment: "")
       }
       return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
