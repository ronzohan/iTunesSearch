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

    @IBOutlet private var searchResultsTableView: UITableView!
    private let searchBar = UITextField()
    private let loadingIndicator = UIActivityIndicatorView()
    private let lastVisitDateLabel = UILabel()
    lazy private var tableHeaderView: UIView = {
        let view = UIView(frame: CGRect())
        view.addSubview(lastVisitDateLabel)
        lastVisitDateLabel.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(8)
        })
        return view
    }()

    private let disposeBag = DisposeBag()
    // ViewDidLoad subject listener so that it can forward this event to the view model
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()

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

        // Set an event on viewDidLoadSubject so that observers to it can react accordingly
        viewDidLoadSubject.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.onNext(())
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
        searchResultsTableView.backgroundColor = .white
        searchResultsTableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Binding
extension HomeViewController {
    private func setupInputBinding() {
        guard let viewModel = viewModel else { return }
        // Bind inputs to the view model
        searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.input.searchQueryString)
            .disposed(by: disposeBag)

        searchResultsTableView.rx.modelSelected(MediaItem.self)
            .bind(to: viewModel.input.selectedMediaItem)
            .disposed(by: disposeBag)

        viewDidLoadSubject
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)

        viewDidAppearSubject
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
    }

    private func setupOutputBinding() {
        guard let viewModel = viewModel else { return }

        let datasource = RxTableViewSectionedAnimatedDataSource<MediaItemSectionModel>(
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

        viewModel.output.lastVisitDate
            .drive(onNext: { [weak self] date in
                self?.lastVisitDateLabel.text = date
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }

            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let smallestPossibleHeight: CGFloat = 0.1
        guard let viewModel = viewModel else { return smallestPossibleHeight }

        return viewModel.showLastVisitHeaderView ? 44 : smallestPossibleHeight
    }
}
