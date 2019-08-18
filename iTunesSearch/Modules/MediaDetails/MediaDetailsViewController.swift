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

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    var viewModel: MediaDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupInputBinding()
        setupOutputBinding()
        viewDidLoadSubject.onNext(())
    }

    private func setupInputBinding() {
        guard let viewModel = viewModel else { return }

        viewDidLoadSubject
            .bind(to: viewModel.input.viewDidLoad)
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

    private func setupView(with mediaItem: MediaItem) {
        titleLabel.text = mediaItem.trackName
        priceLabel.text = "\(mediaItem.currency) \(mediaItem.trackPrice ?? 0)"
        castLabel.text = "\(mediaItem.artistName)"
        let url = URL(string: mediaItem.artworkUrl100 ?? "")
        mediaImageView.kf.setImage(with: url)
        genreLabel.text = mediaItem.primaryGenreName
        descriptionLabel.text = mediaItem.longDescription
    }

    private func setupStyle() {
        descriptionLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        castLabel.numberOfLines = 0
        genreLabel.numberOfLines = 0
    }
}
