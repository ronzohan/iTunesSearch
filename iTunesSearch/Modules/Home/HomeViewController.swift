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
    private struct Constant {
        static let searchPlaceholder = "Search"
    }
    private let disposeBag = DisposeBag()

    private let searchBar = UITextField()
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

        searchBar.rx.text.onNext("star")
        searchBar.sendActions(for: .editingChanged)
    }

    private func setupView() {
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.color = .gray
        setupSearchBar()
    }

    private func setupSearchBar() {
        if let navigationBar = navigationController?.navigationBar {
            searchBar.frame = CGRect(x: 0,
                                     y: 0,
                                     width: navigationBar.frame.width,
                                     height: navigationBar.frame.height - 8)
        }

        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.backgroundColor = .white
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.rightViewMode = .always
        searchBar.clearButtonMode = .whileEditing
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        searchBar.leftViewMode = .always
        searchBar.placeholder = Constant.searchPlaceholder
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
