//
//  ViewControllerFactory.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

struct ViewControllerFactory {
    private init() {}

    static func makeHomeViewController() -> HomeViewController {
        let homeViewController = HomeViewController.instantiateFromNib()
        let repository = HomeViewModelRepository()
        homeViewController.viewModel = HomeViewModel(repository: repository)
        return homeViewController
    }
}
