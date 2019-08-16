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
    }

    struct Output {
        let mediaItems: Driver<[MediaItem]>
    }

    // Input observers
    private let searchQueryStringSubject = PublishSubject<String>()

    // Output observables
    private let mediaItemsSubject = PublishSubject<[MediaItem]>()

    private let disposeBag = DisposeBag()
    private let repository: HomeViewModelRepositoryProtocol

    let input: Input
    let output: Output

    init(repository: HomeViewModelRepositoryProtocol) {
        self.repository = repository
        input = Input(searchQueryString: searchQueryStringSubject.asObserver())
        output = Output(mediaItems: mediaItemsSubject.asDriver(onErrorJustReturn: []))
        setupBinding()
    }

    private func setupBinding() {
        searchQueryStringSubject
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            // Fetch result for query string
            .flatMap { [repository] in repository.searchItunesFor(term: $0, country: "au", media: .movie) }
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    debugPrint(response)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
