//
//  UIAplication+topViewController.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 16/03/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import UIKit

extension UIApplication{
    var topViewController: UIViewController?{
        let keyWindow = self.windows.filter {$0.isKeyWindow}.first
        if let topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                return presentedViewController
            }
        }
        if let navCtl = keyWindow?.rootViewController as? UINavigationController {
            return navCtl.topViewController
        }
        return nil
    }
}
