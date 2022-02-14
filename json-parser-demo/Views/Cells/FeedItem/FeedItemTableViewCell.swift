//
//  FeedItemTableViewCell.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 19/04/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import UIKit
import Kingfisher

class FeedItemTableViewCell: UITableViewCell, NibExtandable {

    var feedItem: FeedItem?{
        didSet{
            if let fi = feedItem{
                titleLabel.text = fi.title
                subtitleLabel.text = fi.subtitle
                if let imageUrl = URL(string: fi.imageUrl){
                    loadImage(with: imageUrl)
                }
            }
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedImageView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = feedImageView.bounds
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.removeFromSuperview()
        activityIndicator.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    private func loadImage(with url: URL){
        activityIndicator.startAnimating()
        feedImageView.kf.setImage(with: url) { [weak self] (_) in
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
