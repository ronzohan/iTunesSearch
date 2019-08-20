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
import SnapKit

class HomeViewController: UIViewController, NibInstantiated {
    private let disposeBag = DisposeBag()

    private let searchBar = UISearchBar()
    @IBOutlet private var searchResultsTableView: UITableView!
    private let loadingIndicator = UIActivityIndicatorView()

    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        setupView()
        setupInputBinding()
        setupOutputBinding()
        setupTableView()
    }

    private func setupView() {
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.color = .gray

        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
    }

    private func setupTableView() {
        searchResultsTableView.rowHeight = UITableView.automaticDimension
        searchResultsTableView.register(nib: MediaItemTableViewCell.self)

        // Remove placeholder lines if there are no items
        searchResultsTableView.tableFooterView = UIView()
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

        searchResultsTableView.rx.modelSelected(MediaItem.self)
            .bind(to: viewModel.input.selectedMediaItem)
            .disposed(by: disposeBag)
    }

    private func setupOutputBinding() {
        guard let viewModel = viewModel else { return }

        let datasource = RxTableViewSectionedReloadDataSource<MediaItemSectionModel>(
            configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
                let cell: MediaItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let viewModel = MediaItemViewModel(mediaItem: item)
                cell.configure(with: viewModel)
                return cell
            }
        )

        viewModel
            .output
            .mediaItems
            .drive(searchResultsTableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

    }
}
