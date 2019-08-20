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
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
    }

    struct Output {
        let mediaItem: Driver<MediaItemProtocol?>
    }

    // Input observers
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()
    private let viewDidDisappearSubject = PublishSubject<Void>()

    // Output observables
    private let mediaItemSubject = PublishSubject<MediaItemProtocol?>()

    private let mediaItem: MediaItemProtocol
    private let disposeBag = DisposeBag()
    private let repository: MediaDetailsRepository

    let input: Input
    let output: Output

    init(mediaItem: MediaItemProtocol, repository: MediaDetailsRepository) {
        self.mediaItem = mediaItem
        self.repository = repository
        input = Input(viewDidLoad: viewDidLoadSubject.asObserver(),
                      viewDidAppear: viewDidAppearSubject.asObserver(),
                      viewDidDisappear: viewDidDisappearSubject.asObserver())
        output = Output(mediaItem: mediaItemSubject.asDriver(onErrorJustReturn: nil))
        setupBinding()

    }

    private func setupBinding() {
        viewDidLoadSubject
            .flatMap { [unowned self] in self.repository.saveMediaItem(self.mediaItem) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.mediaItemSubject.onNext(response)
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)

        /*viewDidAppearSubject
            .compactMap { self.mediaItem.trackId }
            .flatMap { self.repository.setMediaItemVisitDate(withTrackID: $0, date: Date()) }
            .subscribe(onNext: { _ in
                UserDefaults.standard.set(self.mediaItem.trackId, forKey: "mediaItem")
            })
            .disposed(by: disposeBag)*/

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
