//
//  ActivityIndicatorHelper.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 16/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import Foundation
import UIKit

enum LoadingStatus{
    case start
    case stop
}

@available(iOS 13.0, *)
class ActivityIndicator {
    
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let spinnerViewContainer: UIView!
    static var shared = ActivityIndicator()
    
    private init(){
        let size = UIScreen.main.bounds
        spinnerViewContainer = UIView(frame: size)
        spinnerViewContainer.backgroundColor = #colorLiteral(red: 0.7402111888, green: 0.7403369546, blue: 0.7401945591, alpha: 0.2330270687)
        spinnerViewContainer.addSubview(spinnerView)
    }
    
    func setLoading(to status: LoadingStatus){
        if Thread.isMainThread{
            setLoadingOnMainQueue(to: status)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.setLoadingOnMainQueue(to: status)
            }
        }
    }
    
    func setLoadingOnMainQueue(to status: LoadingStatus){
        guard let visibaleVC = UIApplication.shared.topViewController else { return }
        if status == .start{
            spinnerView.startAnimating()
            spinnerView.center = spinnerViewContainer.center
            visibaleVC.view.addSubview(spinnerViewContainer)
        } else {
            spinnerView.stopAnimating()
            spinnerViewContainer.removeFromSuperview()
        }
    }

}
