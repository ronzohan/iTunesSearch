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
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImageView.layer.cornerRadius = 10
        artworkImageView.clipsToBounds = true
    }

    func configure(with mediaItemViewModel: MediaItemViewModel) {
        titleLabel.text = mediaItemViewModel.trackName
        priceLabel.text = mediaItemViewModel.price
        castLabel.text = mediaItemViewModel.artistName
        genreLabel.text = mediaItemViewModel.genre
        if let url = mediaItemViewModel.imageURL {
            artworkImageView.kf.setImage(with: url)
        }
    }
}
