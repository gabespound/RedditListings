//
//  ResponseModels.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/19/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import Foundation

struct ListingResponseModel: Codable {
    let listing: Listing
    
    enum CodingKeys: String, CodingKey {
        case listing = "data"
    }
}

struct Listing: Codable {
    let before: String?
    let after: String?
    let posts: [Post]
    
    enum CodingKeys: String, CodingKey {
        case before
        case after
        case posts = "children"
    }
}

struct Post: Codable {
    let kind: String
    let data: PostData
    
    enum CodingKeys: String, CodingKey {
        case kind
        case data
    }
}

class PostData: Codable { //I needed this to be a reference type, because copy types can't recursively contain eachother
    let title: String?
    let thumbnail: String?
    let articleID: String?
    let commentBody: String?
    let selfText: String?
    let replies: ListingResponseModel?
    let author: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case articleID = "id"
        case commentBody = "body"
        case selfText = "selftext"
        case replies
        case author
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try? container.decode(String.self, forKey: .title)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        articleID = try? container.decode(String.self, forKey: .articleID)
        commentBody = try? container.decode(String.self, forKey: .commentBody)
        selfText = try? container.decode(String.self, forKey: .selfText)
        replies = try? container.decode(ListingResponseModel.self, forKey: .replies)
        author = try? container.decode(String.self, forKey: .author)
    }
    
}
