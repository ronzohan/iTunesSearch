//
//  SearchCoordinator.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchCoordinator: Coordinator {
    private let homeViewController: HomeViewController
    private let navigationController: UINavigationController
    private let repository = MediaDetailsRepository()
    private let disposeBag = DisposeBag()

    var childCoordinators: [Coordinator] = []

    var mainViewController: UIViewController {
        return navigationController
    }

    init() {
        homeViewController = ViewControllerFactory.makeHomeViewController()
        navigationController = UINavigationController(rootViewController: homeViewController)
    }

    func start() {
        homeViewController.viewModel?.delegate = self

        repository.fetchSavedMediaItemTrackId()
            .compactMap { (result) -> Int? in
                switch result {
                case .success(let trackId):
                    return trackId
                default:
                    return nil
                }
            }
            .map { [unowned self] (trackId) in
                return self.repository.existingMediaItem(withTrackID: trackId)
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] mediaItem in
                self?.homeGoToDetail(with: mediaItem, animated: false)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchCoordinator: HomeDelegate {
    func homeGoToDetail(with mediaItem: MediaItemProtocol, animated: Bool) {
        let mediaDetailViewController =
            ViewControllerFactory.makeMediaDetailsViewController(mediaItem: mediaItem)
        navigationController.pushViewController(mediaDetailViewController, animated: animated)
    }
}
