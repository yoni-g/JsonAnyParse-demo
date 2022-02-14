//
//  APIManager.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 18/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation
import Combine

class APIManager {
    
    static var shared = APIManager()
    
    @Published var feedItems: [FeedItem]!
//    var subscriptions = [AnyCancellable]()
    
    private init(){}
    var subscriptions = [AnyCancellable]()
    
    func loadFeedItems(){
        
        
        ActivityIndicator.shared.setLoading(to: .start)
        // MARK: TODO
        // 1. seperate the 2 methods
        // 2. add cache layer to the "WebServiceClient.fetchAllAPISources()" method
        WebServiceClient.loadAPISources()
            .sink(receiveCompletion: { _ in }) { [unowned self] (success) in
                if success {
                    print(success)
                    Publishers
                        .MergeMany(WebServiceClient.fetchAllAPISources())
                        .collect()
                        .compactMap { $0.flatMap { $0 } }
                        .sink(receiveCompletion: { _ in }) { (items) in
                            print(items)
                            self.feedItems = items
                            ActivityIndicator.shared.setLoading(to: .stop)
                        }
                        .store(in: &self.subscriptions)

                }
            }
            .cancel()
    }
}
