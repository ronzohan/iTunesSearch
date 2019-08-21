//
//  MediaItemTableViewCell.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 17/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import UIKit
import Kingfisher

class MediaItemTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var priceButton: UIButton!
    @IBOutlet var rentButton: UIButton!

    func configure(with mediaItemViewModel: MediaItemViewModel) {
        titleLabel.text = mediaItemViewModel.trackName
        priceButton.setTitle(mediaItemViewModel.buyPrice, for: .normal)
        priceButton.isHidden = mediaItemViewModel.buyPrice == nil

        rentButton.setTitle(mediaItemViewModel.rentPrice, for: .normal)
        rentButton.isHidden = mediaItemViewModel.rentPrice == nil

        castLabel.text = mediaItemViewModel.artistName
        genreLabel.text = mediaItemViewModel.genre

        if let url = mediaItemViewModel.imageURL {
            artworkImageView.kf.setImage(with: url)
        }
    }
}
