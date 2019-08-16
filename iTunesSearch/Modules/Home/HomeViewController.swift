//
//  HomeViewController.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HomeViewController: UIViewController, NibInstantiated {
    private let disposeBag = DisposeBag()

    private let searchBar = UISearchBar()
    @IBOutlet var searchResultsTableView: UITableView!

    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        setupInputBinding()
        setupOutputBinding()
    }
}

// MARK: - UI Binding
extension HomeViewController {
    private func setupInputBinding() {
        guard let viewModel = viewModel else { return }

        searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.input.searchQueryString)
            .disposed(by: disposeBag)
    }

    private func setupOutputBinding() {
        guard let viewModel = viewModel else { return }

        
    }
}
