//
//  FeedItem.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 16/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation

//protocol FeedItem {
//    var title: String { set get }
//    var subtitle: String { set get }
//    var imageUrl: String { set get }
//}
//
//enum PathType: String{
//    case array
//    case object
//    case string
//}

enum FeedItemPath{
    case valuePath(path: String)//, type: PathType)
    
    var fullPath: String{
        switch self {
        case .valuePath(let path):
            return path
        }

    }
    
    var pathComponents: [String]{
        fullPath
            .split(separator: ".")
            .compactMap { String($0) }
    }
}


struct FeedItem {
    var title: String
    var subtitle: String
    var imageUrl: String
}
