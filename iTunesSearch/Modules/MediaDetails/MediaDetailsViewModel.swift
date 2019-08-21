//
//  MediaDetailsViewModel.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 18/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MediaDetailsViewModel {
    // MARK: - Input
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
    }

    // MARK: - Output
    struct Output {
        let mediaItemDetailsViewModel: Driver<MediaItemDetailsViewModel?>
    }

    // MARK: - Input observers
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()
    private let viewDidDisappearSubject = PublishSubject<Void>()

    // MARK: - Output observables
    private let mediaItemDetailsViewModelSubject = PublishSubject<MediaItemDetailsViewModel?>()

    // MARK: - Properties
    private let mediaItem: MediaItemProtocol
    private let disposeBag = DisposeBag()
    private let repository: MediaDetailsRepository

    let input: Input
    let output: Output

    // MARK: - Functions
    init(mediaItem: MediaItemProtocol, repository: MediaDetailsRepository) {
        self.mediaItem = mediaItem
        self.repository = repository
        input = Input(viewDidLoad: viewDidLoadSubject.asObserver(),
                      viewDidAppear: viewDidAppearSubject.asObserver(),
                      viewDidDisappear: viewDidDisappearSubject.asObserver())
        output = Output(
            mediaItemDetailsViewModel: mediaItemDetailsViewModelSubject.asDriver(onErrorJustReturn: nil)
        )
        setupBinding()

    }

    private func setupBinding() {
        viewDidLoadSubject
            .flatMap { [unowned self] in self.repository.saveOrUpdate(self.mediaItem) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let viewModel = MediaItemDetailsViewModel(mediaItem: response)
                    self?.mediaItemDetailsViewModelSubject.onNext(viewModel)
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)

        viewDidDisappearSubject
            .map { self.mediaItem.trackId }
            .compactMap { $0 }
            .flatMap { [unowned self] in self.repository.removeMediaItem(withTrackID: $0) }
            .subscribe(onNext: { result in
                debugPrint(result)
            })
            .disposed(by: disposeBag)
    }
}
