//
//  WebServiceClient.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 16/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation
import Combine

typealias WSResponse = AnyPublisher<[FeedItem], URLError>

class WebServiceClient {

    private static var webServices = [WebServiceEndpoint]()
    
    static func loadAPISources() -> AnyPublisher<Bool, Error>{

        // MARK: mock call to our WS to fetch all data sources/endpoints
        // MARK: TODO: replace Consts with a real WS call in the future
        Constants.Datasource.allCases.forEach { (dataSource) in
            let ws = WebServiceEndpoint(
                sourceName: dataSource.rawValue,
                sourceUrl: dataSource.urlString,
                cacheTime: dataSource.cacheTime,
                titlePath: dataSource.titlePath,
                subtitlePath: dataSource.subtitlePath,
                imagePath: dataSource.imagePath
            )
            webServices.append(ws)
        }
        // return a mock combine reponse
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }
    
    static func fetchAllAPISources() -> [WSResponse]{
        
        let publishers = webServices.map { (ws) -> WSResponse? in
            if let url = ws.url() {
                return URLSession.shared
                    .dataTaskPublisher(for: url)
                    .compactMap({ (data, _) -> [FeedItem]? in
                        FeedItemsParser.parseResponse(with: data, wsEndpoint: ws)
                    })
                    .eraseToAnyPublisher()
                
            }
            return nil
        }
        return publishers.compactMap { $0 }
    }
  
}
