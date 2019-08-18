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
    }

    struct Output {
        let mediaItem: Driver<MediaItem?>
    }

    // Input observers
    private let viewDidLoadSubject = PublishSubject<Void>()

    // Output observables
    private let mediaItemSubject = PublishSubject<MediaItem?>()

    private let mediaItem: MediaItem
    private let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        input = Input(viewDidLoad: viewDidLoadSubject.asObserver())
        output = Output(mediaItem: mediaItemSubject.asDriver(onErrorJustReturn: nil))
        setupBinding()

    }

    private func setupBinding() {
        viewDidLoadSubject
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mediaItemSubject.onNext(strongSelf.mediaItem)
            })
            .disposed(by: disposeBag)
    }
}
