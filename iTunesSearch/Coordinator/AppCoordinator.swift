//
//  AppCoordinator.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let searchCoordinator: SearchCoordinator
    private let initialViewController: UIViewController

    var mainViewController: UIViewController {
        return initialViewController
    }

    private var window: UIWindow
    private var authManager: AuthManagerProtocol

    init(window: UIWindow, authManager: AuthManagerProtocol) {
        self.window = window
        self.authManager = authManager
        searchCoordinator = SearchCoordinator()
        initialViewController = searchCoordinator.mainViewController
    }

    func start() {
        addChildCoordinator(searchCoordinator)
        searchCoordinator.start()
        window.rootViewController = mainViewController
    }

    private func setupWindow() {
        window.backgroundColor = .white
    }
}
