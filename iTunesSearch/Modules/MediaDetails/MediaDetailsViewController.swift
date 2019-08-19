//
//  MediaDetailsViewController.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 18/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class MediaDetailsViewController: UIViewController, NibInstantiated {
    // Thread safe bag that disposes added disposables/observables for the purpose of
    // resource management in RxSwift
    private let disposeBag = DisposeBag()

    // Observable for viewDidLoad so that MediaDetailsViewController
    // can forward viewDidLoad event to its ViewModel
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()
    private let viewDidDisappearSubject = PublishSubject<Void>()

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var lastVisitDateLabel: UILabel!

    var viewModel: MediaDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupInputBinding()
        setupOutputBinding()
        viewDidLoadSubject.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.onNext(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearSubject.onNext(())
    }

    private func setupInputBinding() {
        guard let viewModel = viewModel else { return }

        viewDidLoadSubject
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)

        viewDidAppearSubject
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)

        viewDidDisappearSubject
            .bind(to: viewModel.input.viewDidDisappear)
            .disposed(by: disposeBag)
    }

    private func setupOutputBinding() {
        guard let viewModel = viewModel else { return }
        viewModel
            .output
            .mediaItem
            .drive(onNext: { [weak self] mediaItem in
                guard let mediaItem = mediaItem else { return }
                self?.setupView(with: mediaItem)
            })
            .disposed(by: disposeBag)
    }

    private func setupView(with mediaItem: MediaItemProtocol) {
        titleLabel.text = mediaItem.trackName
        priceLabel.text = "\(mediaItem.currency ?? "AUD") \(mediaItem.trackPrice ?? 0)"
        castLabel.text = mediaItem.artistName
        let url = URL(string: mediaItem.artworkUrl100 ?? "")
        mediaImageView.kf.setImage(with: url)
        genreLabel.text = mediaItem.primaryGenreName
        descriptionLabel.text = mediaItem.longDescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"

        if let date = mediaItem.lastVisitDate {
            lastVisitDateLabel.text = dateFormatter.string(from: date)
        }

        lastVisitDateLabel.isHidden = mediaItem.lastVisitDate == nil
    }

    private func setupStyle() {
        descriptionLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        castLabel.numberOfLines = 0
        genreLabel.numberOfLines = 0
    }
}
