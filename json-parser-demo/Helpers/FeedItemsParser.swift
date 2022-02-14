//
//  FeedItemsParser.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 18/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation

struct FeedItemsParser {
    
    static func parseResponse(with data: Data, wsEndpoint: WebServiceEndpoint) -> [FeedItem]?{
        
        if let dict = parse(data, as: NSDictionary.self){
            
            var items: [FeedItem]?
            dict.allKeys.forEach { (key) in
                // if we found the items list -> parse it
                if let arr = dict[key] as? NSArray{
                    items = arr.compactMap { getFeedItem(from: $0 as? NSDictionary, with: wsEndpoint) }
                // otherwise (it's a nother dict) lets get a layer deeper
                } else if let obj = dict[key] as? NSDictionary, let objData = encode(obj) {
                    items = parseResponse(with: objData, wsEndpoint: wsEndpoint)
                }
            }
            return items
        }
//        }
        
        if let array = parse(data, as: NSArray.self){
            
            return array.compactMap { getFeedItem(from: $0 as? NSDictionary, with: wsEndpoint) }
        }
        return nil
    }
    

    static func getFeedItem(from dict: NSDictionary?, with wsEndpoint: WebServiceEndpoint) -> FeedItem?{
        // todo: can change to something generic with case iteration and generics..
        guard let dic = dict,
              let title    = getValue(for: wsEndpoint.titlePath, from: dic),
              let subtitle = getValue(for: wsEndpoint.subtitlePath, from: dic),
              let imgUrl   = getValue(for: wsEndpoint.imagePath, from: dic) else {
            return nil
        }
        return FeedItem(title: title, subtitle: subtitle, imageUrl: imgUrl)
    }


    
    static func getValue(for path: String, from dict: NSDictionary) -> String?{
        var valueString: String?
        for key in dict.allKeys {
            guard let strKey = key as? String else { return nil }

            // if we found the item -> return it
            if path.contains(strKey){
                valueString = getString(from: dict, with: path)
                return valueString
            // otherwise (it's a nother dict) lets get a layer deeper
            } else if let obj = dict[key] as? NSDictionary{
                valueString = getValue(for: path, from: obj)

            }
        }
        return valueString
    }
//
    static func getString(from dict: NSDictionary, with lastPart: String) -> String?{
        // check if need to take from multiple fields
        let splited = lastPart
            .split(separator: "+")
            .compactMap { String($0) }
        
        return splited
            .compactMap {  dict.value(forKey: $0) as? String }
            .joined()
    }
    
    private static func encode(_ object: Any) -> Data?{
        return try? JSONSerialization.data(
            withJSONObject: object,
            options: []
        )
    }

    private static func parse<T>(_ data: Data, as type: T.Type) -> T?{
        try? JSONSerialization.jsonObject(with: data, options: []) as? T
    }
    
    
//    func getValue<T>(from: NSDictionary, as type: T.Type, for fieldName: String) -> T?{
//
//        return nil
//    }
//

    
    //    static func getValue(for path: [String], from dict: NSDictionary) -> String?{
    //
    //        // this is the actual field comp
    //        if path.count > 1{
    //            return getValue(for: path.dropFirst().compactMap { $0 }, from: dict)
    //        }
    //
    //        if let pathComp = path.first?
    //            .split(separator: "-")
    //            .compactMap({ String($0) }){
    //            // if it has only one part meaning it's a string value dict
    //            if pathComp.count == 1{
    //                return getString(from: dict, with: pathComp.first!)
    //            }
    //            if let type = pathComp.last, let name = pathComp.first{
    //                if type == "array"{
    //                    let array = dict[name] as? NSArray
    //                    return array?
    //                        .compactMap { $0 as? NSDictionary }
    //                        .compactMap { return getValue(for: [name], from: $0) }
    //                        .first
    //                } else if type == "object"{
    //                    if let obj = dict[name] as? NSDictionary{
    //                        return getValue(for: [name], from: obj)
    //                    }
    //                }
    //            }
    //        }
    //        return nil
    //    }
    //
    
    //    private static func parseDictionary(from data: Data) -> NSDictionary?{
    //        return try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
    //    }
    //
    //    private static func parseFlatArray(from data: Data) -> NSArray?{
    //        return try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray
    //    }
    
    
    //    private static func parseFlatArray(from data: Data, wsEndpoint: WebServiceEndpoint) -> [FeedItem]?{
    //        if let array = try? JSONSerialization.jsonObject(with: data, options: []) as? NSArray{
    //            print(array)
    //            return array.compactMap { getFeedItem(from: $0 as? NSDictionary, with: wsEndpoint) }
    //        }
    //        return nil
    //    }
    
    //
    //    static func getFeedItem(from data: Data, with wsEndpoint: WebServiceEndpoint) -> FeedItem?{
    //        // todo: can change to something generic with case iteration and generics..
    //        guard let title    = getValue(for: wsEndpoint.titlePath.pathComponents, from: data),
    //              let subtitle = getValue(for: wsEndpoint.subtitlePath.pathComponents, from: data),
    //              let imgUrl   = getValue(for: wsEndpoint.imagePath.pathComponents, from: data) else {
    //            return nil
    //        }
    //        return FeedItem(title: title, subtitle: subtitle, imageUrl: imgUrl)
    //    }

//    static func getValue(for path: [String], from data: Data) -> String?{
//
//        if path.count > 1{
//            return getValue(for: path.dropFirst().compactMap { $0 }, from: data)
//        }
//
//        if let pathComp = path.first?
//            .split(separator: "-")
//            .compactMap({ String($0) }){
//            // if it has only one part meaning it's a string value dict
//            if pathComp.count == 1{
//                if let dict = parseDictionary(from: data),
//                   let first = pathComp.first{
//                    return getString(from: dict, with: first)
//                }
//            }
//            guard let dict = parseDictionary(from: data) else { return "" }
//
//            if let type = pathComp.last, let name = pathComp.first{
//                if type == "array"{
//                    if let array = dict[name] as? NSArray{
//
//                        return array
//                            .compactMap { encode($0) }
//                            .compactMap { return getValue(for: [name], from: $0) }
//                            .first
//                    }
//                } else if type == "object"{
//                    if let obj = dict[name] as? NSDictionary{
//                        if let data = encode(obj){
//                            return getValue(for: [name], from: data)
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
//    
}


//struct ArrayResponse: Decodable {
//    let array: [JSONResponse]
//}
//
//struct JSONResponse: Decodable {
//
//    let items: [String : String]
//
//    private struct Keys : CodingKey {
//
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//
//        var intValue: Int?
//        init?(intValue: Int) {
//            return nil
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        let con = try! decoder.container(keyedBy: Keys.self)
//        var d = [String : String]()
//        for key in con.allKeys {
//            let value = try? con.decode(String.self, forKey:key)
//            d[key.stringValue] = value
//        }
//        self.items = d
//    }
//}
