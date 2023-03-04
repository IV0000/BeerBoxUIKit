//
//  BannerView.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 04/03/23.
//

import UIKit

class BannerView: UIView {
    private let bannerImage = UIImageView(image: UIImage(named: "banner"))
    private let bannerTitleLabel = UILabel()
    private let bannerDescriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        backgroundColor = Palette.bannerColor
        layer.cornerRadius = 12

        bannerImage.contentMode = .scaleToFill

        bannerTitleLabel.text = "Weekend offers"
        bannerTitleLabel.textAlignment = .left
        bannerTitleLabel.textColor = Palette.darkTextColor
        bannerTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)

        bannerDescriptionLabel.text = "Free shipping on orders over 60$"
        bannerDescriptionLabel.textAlignment = .left
        bannerDescriptionLabel.textColor = Palette.darkTextColor
        bannerDescriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }

    private func setConstraints() {
        addConstrainedSubview(bannerImage,
                              bannerTitleLabel,
                              bannerDescriptionLabel)

        NSLayoutConstraint.activate([
            bannerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            bannerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),

            bannerDescriptionLabel.topAnchor.constraint(equalTo: bannerTitleLabel.bottomAnchor),
            bannerDescriptionLabel.leadingAnchor.constraint(equalTo: bannerTitleLabel.leadingAnchor),

            bannerImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            bannerImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
}
