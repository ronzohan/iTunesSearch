//
//  SearchCoordinator.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinator {
    private let homeViewController: HomeViewController
    private let navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var mainViewController: UIViewController {
        return navigationController
    }

    init() {
        homeViewController = ViewControllerFactory.makeHomeViewController()
        navigationController = UINavigationController(rootViewController: homeViewController)
    }

    func start() {

    }
}
