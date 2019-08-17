//
//  UITableView+Dequeueing.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 17/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(nib cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(withIdentifier identifier: String,
                                                 for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier,
                                                  for: indexPath) as? T
            else {
                fatalError("Cannot dequeue \(T.self)")
        }

        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier,
                                                  for: indexPath) as? T
            else {
                fatalError("Cannot dequeue \(T.self)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withIdentifier identifier: String)
        -> T? {
            guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
                return nil
            }

            return view
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView & ReusableView>() -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Cannot dequeue \(T.self)")
        }

        return view
    }
}
