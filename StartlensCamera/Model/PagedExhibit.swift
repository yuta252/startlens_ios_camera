//
//  PagedExhibit.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/25.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct PagedExhibit: Codable {
    var meta: Meta
    var data: [Exhibit]
}
