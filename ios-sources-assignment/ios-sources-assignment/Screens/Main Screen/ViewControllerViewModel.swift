//
//  ViewControllerViewModel.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 18/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ViewControllerViewModel {
    
    var subscriptions = [AnyCancellable]()
    @Published var feedItems: [FeedItem]!
    
    func subscribeToFeedItemsAPI(){
        
        APIManager.shared.$feedItems
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [unowned self] in
                self.feedItems = $0
            }
            .store(in: &subscriptions)
        
    }
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(
            FeedItemTableViewCell.nib,
            forCellReuseIdentifier: FeedItemTableViewCell.cellNibId
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
}
