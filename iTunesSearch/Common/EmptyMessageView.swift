//
//  EmptyMessageView.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 21/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//
import Foundation
import UIKit

class EmptyMessageView: UIView {
    struct Constant {
        static let refreshText = "Reload"
        static let spacing: CGFloat = 16
        static let imageViewHeight: CGFloat = 100
    }

    let messageLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

    var onRefresh: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        setupStyle()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constant.spacing
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(descriptionLabel)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constant.spacing)
        }

        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.imageViewHeight)
        }

        backgroundColor = .white
    }

    private func setupStyle() {
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.black

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.black
    }

    @objc private func didTapRefreshButton() {
        onRefresh?()
    }
}

extension EmptyMessageView {
    class func withMessage(_ message: String,
                           details: String? = nil,
                           image: UIImage? = nil) -> EmptyMessageView {
        let messageView = EmptyMessageView()
        messageView.messageLabel.text = message
        messageView.descriptionLabel.text = details
        messageView.imageView.image = image

        messageView.imageView.isHidden = image == nil
        messageView.descriptionLabel.isHidden = details == nil

        return messageView
    }
}
