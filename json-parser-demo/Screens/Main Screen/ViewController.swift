
//  Copyright © 2018 Chegg. All rights reserved.

import UIKit
import Combine

class ViewController: UIViewController {

    var viewModel: ViewControllerViewModel!
    var subscriptions = [AnyCancellable]()
    var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        subscribreToFeed()
    }
    
    func subscribreToFeed(){
        viewModel.$feedItems
            .compactMap { $0 }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink(receiveValue: handleFeedItemsLoaded)
            .store(in: &subscriptions)
        
        viewModel.subscribeToFeedItemsAPI()
    }
    
    func configTableView(){
        feedTableView = viewModel.tableView
        feedTableView.frame = view.frame
        feedTableView.dataSource = self
        feedTableView.delegate = self
        view.addSubview(feedTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func handleFeedItemsLoaded(items: [FeedItem]){
        print("done")
        // todo: handle reloading of specific feed items based on the source..
        feedTableView.reloadData()
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.feedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemTableViewCell.cellNibId) as? FeedItemTableViewCell{
            let feedItem = viewModel.feedItems[indexPath.row]
            cell.feedItem = feedItem
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

