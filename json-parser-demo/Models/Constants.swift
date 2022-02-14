
//  Copyright © 2018 Chegg. All rights reserved.

import Foundation

public struct Constants {
    static let baseUrl = "http://chegg-mobile-promotions.cheggcdn.com/ios/home-assignments/"
    
    public enum Datasource : String, CaseIterable {
        case sourceA = "source_a.json"
        case sourceB = "source_b.json"
        case sourceC = "source_c.json"

        public func sourceUrl() -> URL? {
            return URL(string: "\(Constants.baseUrl)\(self.rawValue)")
        }
    }
}

extension Constants.Datasource{
    var cacheTime: TimeInterval? {
        switch self {
        case .sourceA:
            return 5 * 60
        case .sourceB:
            return 10 * 60
        case .sourceC:
            return 60 * 60
        }
    }
    
    var urlString: String{
        "\(Constants.baseUrl)\(self.rawValue)"
    }

    var titlePath: String{
        switch self {
        case .sourceA:
            return "title"
        case .sourceB:
            return "header"
        case .sourceC:
            return "topLine"
        }
    }
    
    var subtitlePath: String{
        switch self {
        case .sourceA:
            return "subtitle"
        case .sourceB:
            return "description"
        case .sourceC:
            return "subLine1+subline2"
        }
    }
    
    var imagePath: String{
        switch self {
        case .sourceA:
            return "imageUrl"
        case .sourceB:
            return "picture"
        case .sourceC:
            return "image"
        }
    }
    
}


