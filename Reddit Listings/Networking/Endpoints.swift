//
//  Endpoints.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/19/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import Foundation

enum SubReddits: String {
    case sourdough = "/r/sourdough/"
    
    func asString() -> String {
        let startInd = rawValue.index(rawValue.startIndex, offsetBy: 3)
        let endInd = rawValue.index(before: rawValue.endIndex)
        let range = startInd..<endInd
        let string = rawValue[range]
        return String(string).capitalized
    }
}

enum ListingTypes: String {
    case hot = "hot.json"
    case new = "new.json"
    case top = "top.json"
    case rising = "rising.json"
}
