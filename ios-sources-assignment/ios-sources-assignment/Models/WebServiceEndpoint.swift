//
//  WebServiceEndpoint.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 16/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation

//enum ResponseRoot: String{
//    case flatArray
//    case objectArray
//    case object
//    case none
//
//}

struct WebServiceEndpoint {
    var sourceName: String
    var sourceUrl: String
    var cacheTime: TimeInterval?
    var titlePath: String
    var subtitlePath: String
    var imagePath: String
//    var itemsListName: String?
//    var responseRoot: ResponseRoot?
}

extension WebServiceEndpoint{
    func url() -> URL? {
        URL(string: sourceUrl)
    }
}
