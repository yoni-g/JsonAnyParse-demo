//
//  NibExtandable.swift
//  ios-sources-assignment
//
//  Created by Yonathan Goriachnick on 19/04/2021.
//  Copyright © 2021 Chegg. All rights reserved.
//

import UIKit.UITableViewCell

protocol NibExtandable where Self: UITableViewCell{
    static var cellNibId: String { get }
    static var nib: UINib { get }
}

extension NibExtandable{
    
    static var nib: UINib{
        UINib(nibName: cellNibId, bundle: nil)
    }
    
    static var cellNibId: String{
        String(describing: Self.classForCoder())
    }
}
