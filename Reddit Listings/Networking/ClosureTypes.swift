//
//  ClosureTypes.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/19/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import Foundation

struct ClosureTypes {
    typealias ListingResponseClosure = (ListingResponseModel?) -> Void
    typealias ListingsResponseClosure = ([ListingResponseModel]?) -> Void
    typealias LoadImageDataClosure = (Data) -> Void
}
