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

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleDetail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.titleColor
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()

    lazy var taglineLabel: UILabel = {
        let label = UILabel()
        label.text = taglineDetail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptionDetail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    lazy var beerImage: UIImageView = {
        let image = UIImageView()
        image.downloaded(from: imageUrl!)
        return image

    }()

    lazy var bookmarkImage: UIImageView = {
        let bookmark = UIImageView()
        bookmark.image = UIImage(systemName: "bookmark.fill")!.withTintColor(Palette.primaryColor, renderingMode: .alwaysOriginal)
        return bookmark
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.backgroundColor
        configureUI()
        setupConstraints()
    }

    func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(taglineLabel)
        view.addSubview(beerImage)
        view.addSubview(bookmarkImage)
    }

    func setupConstraints() {
        bookmarkImage.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bookmarkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        bookmarkImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        bookmarkImage.heightAnchor.constraint(equalToConstant: 25).isActive = true

        beerImage.translatesAutoresizingMaskIntoConstraints = false
        beerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        beerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        beerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
        beerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: beerImage.trailingAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        titleLabel.topAnchor.constraint(equalTo: beerImage.topAnchor).isActive = true

        taglineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        taglineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

        descriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 10).isActive = true
    }
}
