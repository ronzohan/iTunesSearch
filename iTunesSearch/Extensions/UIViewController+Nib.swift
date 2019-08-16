//
//  UIViewController+Nib.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//
import Foundation
import UIKit

protocol NibInstantiated {
    static var identifier: String { get }
}

extension NibInstantiated where Self: UIViewController {
    static func instantiateFromNib(bundle: Bundle = .main) -> Self {
        let viewController = Self(nibName: identifier, bundle: bundle)
        return viewController
    }

    static var identifier: String {
        return String(describing: self)
    }
}
