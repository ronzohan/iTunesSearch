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

    func configure(with mediaItem: MediaItem) {
        titleLabel.text = mediaItem.trackName
        priceLabel.text = "\(mediaItem.currency) \(mediaItem.trackPrice ?? 0)"
        castLabel.text = "\(mediaItem.artistName)"
        let url = URL(string: mediaItem.artworkUrl100 ?? "")
        artworkImageView.kf.setImage(with: url)
        genreLabel.text = mediaItem.primaryGenreName
    }
}
