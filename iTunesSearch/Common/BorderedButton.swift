//
//  BorderedButton.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 21/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

class BorderedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        setTitleColor(.black, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}
