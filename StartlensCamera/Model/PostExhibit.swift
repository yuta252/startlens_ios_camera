//
//  PostExhibit.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/26.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct PostExhibit: Codable {
    var lang: String
    var name: String
    var description: String
    var imageFile: [String]?
    
    init(lang: String, name: String, description: String) {
        self.lang = lang
        self.name = name
        self.description = description
    }
    
    mutating func setImageFile(image: String) {
        imageFile?.append(image)
    }
}
