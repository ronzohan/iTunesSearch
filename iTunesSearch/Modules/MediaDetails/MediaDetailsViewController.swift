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
    @IBOutlet var buyPriceButton: UIButton!
    @IBOutlet var rentPriceButton: UIButton!

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
            .mediaItemDetailsViewModel
            .drive(onNext: { [weak self] viewModel in
                guard let viewModel = viewModel else { return }
                self?.setupView(with: viewModel)
            })
            .disposed(by: disposeBag)
    }

    private func setupView(with mediaItemViewModel: MediaItemDetailsViewModel) {
        titleLabel.text = mediaItemViewModel.trackName

        buyPriceButton.setTitle(mediaItemViewModel.buyPrice, for: .normal)
        buyPriceButton.isHidden = mediaItemViewModel.buyPrice == nil

        rentPriceButton.setTitle(mediaItemViewModel.rentPrice, for: .normal)
        rentPriceButton.isHidden = mediaItemViewModel.rentPrice == nil

        castLabel.text = mediaItemViewModel.artistName
        if let url = mediaItemViewModel.imageURL {
            mediaImageView.kf.setImage(with: url)
        }

        genreLabel.text = mediaItemViewModel.genre
        descriptionLabel.text = mediaItemViewModel.longDescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
    }

    private func setupStyle() {
        descriptionLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        castLabel.numberOfLines = 0
        genreLabel.numberOfLines = 0
    }
}
