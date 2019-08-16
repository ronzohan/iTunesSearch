//
//  Coordinator.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var mainViewController: UIViewController { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

/// Coordinator helper functions for keeping track of which child coordinators were added to itself so
/// that it can be removed properly when the coordinator is finished using it thus avoiding
/// unnecessary memory leak
extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        addChildCoordinators([coordinator])
    }

    func addChildCoordinators(_ coordinators: [Coordinator]) {
        childCoordinators.append(contentsOf: coordinators)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }

    func removeChildCoordinator<T: Coordinator>(_ coordinator: T.Type) {
        childCoordinators = childCoordinators.filter { !($0 is T) }
    }
}
