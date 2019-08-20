//
//  HomeViewModel.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    struct Constant {
        static let lastVisitDateText = "Last Visit:"
    }

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let viewDidAppear: AnyObserver<Void>
        let searchQueryString: AnyObserver<String>
        let selectedMediaItem: AnyObserver<MediaItem>
    }

    struct Output {
        let mediaItems: Driver<[MediaItemSectionModel]>
        let isLoading: Driver<Bool>
        let lastVisitDate: Driver<String?>
    }

    // Input observers
    private let searchQueryStringSubject = PublishSubject<String>()
    private let selectedMediaItem = PublishSubject<MediaItem>()
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()

    // Output observables
    private let mediaItemsSubject = PublishSubject<[MediaItemSectionModel]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let lastVisitDateSubject = PublishSubject<String?>()

    private let disposeBag = DisposeBag()
    private let repository: HomeViewModelRepositoryProtocol

    weak var delegate: HomeDelegate?

    let input: Input
    let output: Output

    private(set) var showLastVisitHeaderView = false

    init(repository: HomeViewModelRepositoryProtocol) {
        self.repository = repository
        input = Input(viewDidLoad: viewDidLoadSubject.asObserver(),
                      viewDidAppear: viewDidAppearSubject.asObserver(),
                      searchQueryString: searchQueryStringSubject.asObserver(),
                      selectedMediaItem: selectedMediaItem.asObserver())
        output = Output(mediaItems: mediaItemsSubject.asDriver(onErrorJustReturn: []),
                        isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
                        lastVisitDate: lastVisitDateSubject.asDriver(onErrorJustReturn: nil))
        setupBinding()
    }

    private func setupBinding() {
        viewDidLoadSubject
            .flatMap { [repository] in repository.lastVisitDate() }
            // Convert the result to just a date
            .map({ result -> Date? in
                switch result {
                case .success(let lastVisitDate):
                    return lastVisitDate
                case .failure:
                    return nil
                }
            })
            .do(onNext: { [weak self] date in
                self?.showLastVisitHeaderView = date != nil
            })
            // Remove all nil values
            .compactMap { $0 }
            // Process date
            .do(onNext: { [weak self] date in self?.handleLastVisitDate(date) })
            .flatMap({ [repository] _ in return repository.updateVisitDate() })
            .subscribe()
            .disposed(by: disposeBag)

        viewDidAppearSubject
            .flatMap { self.repository.updateVisitDate() }
            .subscribe()
            .disposed(by: disposeBag)

        searchQueryStringSubject
            // Add a timer on when to search for the query
            // so that api will not be called everytime if the user is typing very fast
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            // Show loading indicator
            .do(onNext: { [weak self] _ in
                self?.isLoadingSubject.onNext(true)
            })
            // Fetch result for query string
            .flatMap { [repository] in repository.searchItunesFor(term: $0, country: "au", media: .movie) }
            // Hide loading indicator
            .do(onNext: { [weak self] _ in self?.isLoadingSubject.onNext(false) })
            .subscribe(onNext: { [weak self] result in self?.handleSearchResponseResult(result) })
            .disposed(by: disposeBag)

        selectedMediaItem
            .subscribe(onNext: { [weak self] item in
                self?.delegate?.homeGoToDetail(with: item, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func handleLastVisitDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d yyyy"
        let lastVisitText = "\(Constant.lastVisitDateText) \(dateFormatter.string(from: date))"
        lastVisitDateSubject.onNext(lastVisitText)
    }

    private func handleSearchResponseResult(_ result: Result<SearchResponse, Error>) {
        switch result {
        case .success(let response):
            let mediaItemSectionModels = mediaItemSectionModel(for: response.results)
            mediaItemsSubject.onNext([mediaItemSectionModels])
        default:
            break
        }
    }

    private func mediaItemSectionModel(for mediaItems: [MediaItem]) -> MediaItemSectionModel {
        let sectionModel = MediaItemSectionModel(items: mediaItems)
        return sectionModel
    }
}
