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
    struct Input {
        let searchQueryString: AnyObserver<String>
        let selectedMediaItem: AnyObserver<MediaItem>
    }

    struct Output {
        let mediaItems: Driver<[MediaItemSectionModel]>
        let isLoading: Driver<Bool>
    }

    // Input observers
    private let searchQueryStringSubject = PublishSubject<String>()
    private let selectedMediaItem = PublishSubject<MediaItem>()

    // Output observables
    private let mediaItemsSubject = PublishSubject<[MediaItemSectionModel]>()
    private let isLoadingSubject = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()
    private let repository: HomeViewModelRepositoryProtocol

    weak var delegate: HomeDelegate?

    let input: Input
    let output: Output

    init(repository: HomeViewModelRepositoryProtocol) {
        self.repository = repository
        input = Input(searchQueryString: searchQueryStringSubject.asObserver(),
                      selectedMediaItem: selectedMediaItem.asObserver())
        output = Output(mediaItems: mediaItemsSubject.asDriver(onErrorJustReturn: []),
                        isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false))
        setupBinding()
    }

    private func setupBinding() {
        searchQueryStringSubject
            // Add a timer on when to search for the query
            // so that api will not be called everytime if the user is typing very fast
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            // Show loading indicator
            .do(onNext: { [weak self] _ in
                self?.isLoadingSubject.onNext(true)
            })
            // Fetch result for query string
            .flatMap { [repository] in repository.searchItunesFor(term: $0,
                                                                  country: "au",
                                                                  media: .movie) }
            // Hide loading indicator
            .do(onNext: { [weak self] _ in
                self?.isLoadingSubject.onNext(false)
            })
            .subscribe(onNext: { [weak self] result in
                guard let strongSelf = self else { return }

                switch result {
                case .success(let response):
                    let mediaItemSectionModels = strongSelf.mediaItemSectionModel(for: response.results)
                    self?.mediaItemsSubject.onNext([mediaItemSectionModels])
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        selectedMediaItem
            .subscribe(onNext: { [weak self] item in
                self?.delegate?.homeGoToDetail(with: item)
            })
            .disposed(by: disposeBag)
    }

    private func mediaItemSectionModel(for mediaItems: [MediaItem]) -> MediaItemSectionModel {
        let sectionModel = MediaItemSectionModel(items: mediaItems)
        return sectionModel
    }
}
