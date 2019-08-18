//
//  MediaDetailsViewController.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 18/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import UIKit
import Kingfisher

class MediaDetailsViewController: UIViewController, NibInstantiated {
    @IBOutlet var bannerImageView: UIImageView!

    var viewModel: MediaDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

