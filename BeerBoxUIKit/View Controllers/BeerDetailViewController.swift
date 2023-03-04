//
//  BeerDetailViewController.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class BeerDetailViewController: UIViewController {
    var titleDetail: String?
    var taglineDetail: String?
    var descriptionDetail: String?
    var imageUrl: String?

    private let titleLabel = UILabel()
    private let taglineLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var bookmark = UIImageView()
    private var beerImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setStyle()
    }

    func setStyle() {
        view.backgroundColor = Palette.backgroundColor

        titleLabel.text = titleDetail
        titleLabel.textColor = Palette.titleColor
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1

        taglineLabel.text = taglineDetail
        taglineLabel.textColor = Palette.textColor
        taglineLabel.font = .systemFont(ofSize: 18)
        taglineLabel.adjustsFontSizeToFitWidth = true
        taglineLabel.minimumScaleFactor = 0.5
        taglineLabel.numberOfLines = 1

        descriptionLabel.text = descriptionDetail
        descriptionLabel.textColor = Palette.textColor
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0

        let systemIcon = UIImage(systemName: "bookmark.fill")!
        systemIcon.withTintColor(Palette.primaryColor, renderingMode: .alwaysOriginal)
        bookmark.image = systemIcon

        if let imageUrl = imageUrl {
            beerImage.downloaded(from: imageUrl)
        }
    }

    func setConstraints() {
        view.addConstrainedSubview(bookmark,
                                   beerImage,
                                   titleLabel,
                                   taglineLabel,
                                   descriptionLabel)

        NSLayoutConstraint.activate([
            bookmark.topAnchor.constraint(equalTo: view.topAnchor),
            bookmark.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bookmark.widthAnchor.constraint(equalToConstant: 25),
            bookmark.heightAnchor.constraint(equalToConstant: 25),

            beerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            beerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            beerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            beerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35),

            titleLabel.leadingAnchor.constraint(equalTo: beerImage.trailingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            titleLabel.topAnchor.constraint(equalTo: beerImage.topAnchor),

            taglineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            taglineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            descriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 10),
        ])
    }
}
