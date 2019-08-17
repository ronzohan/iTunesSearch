//
//  UIView+Reusable.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 17/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//
import Foundation
import UIKit

protocol ReusableView {
    static var identifier: String { get }
}

extension ReusableView {
    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UICollectionViewCell: ReusableView {}

extension UITableViewCell: ReusableView {}
