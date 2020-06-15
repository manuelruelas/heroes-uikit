//
//  SearchHeroResponse.swift
//  heroes-uikit
//
//  Created by Jorge Guzman on 15/06/20.
//  Copyright © 2020 mruelas. All rights reserved.
//

import Foundation
struct SearchHeroResponse: Decodable {
    var response:String
    var results: [Hero]
}
