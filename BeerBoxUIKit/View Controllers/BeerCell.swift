//
//  BeerCell.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import SwiftUI
import UIKit

class BeerCell: UITableViewCell {
    var buttonPressed: (() -> Void) = {}
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.titleColor
        return label
    }()

    lazy var taglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        label.numberOfLines = 2
        return label
    }()

    lazy var moreInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Palette.primaryColor, for: .normal)
        button.setTitleColor(Palette.primaryColor.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
        return button
    }()

    lazy var beerImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pressedAction(_: UIButton) {
        buttonPressed()
    }

    func configure(beer: Beer) {
        titleLabel.text = beer.name
        taglineLabel.text = beer.tagline
        descriptionLabel.text = beer.description
        moreInfoButton.setTitle("MORE INFO", for: .normal)
        beerImage.downloaded(from: beer.imageURL, contentMode: .scaleToFill)
        contentView.addSubview(titleLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(moreInfoButton)
        contentView.addSubview(beerImage)
        contentView.backgroundColor = Palette.backgroundColor
        setConstraints()
    }

    func setConstraints() {
        beerImage.translatesAutoresizingMaskIntoConstraints = false
        beerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        beerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        beerImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        beerImage.heightAnchor.constraint(equalToConstant: 100).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: beerImage.trailingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true

        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true

        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        moreInfoButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: -5).isActive = true
    }
}

// MARK: Preview

struct BeerCellRepresentable: UIViewRepresentable {
    func makeUIView(context _: Context) -> some UIView {
        let mockBeer = Beer(id: 1,
                            name: "Punk Ipa",
                            tagline: "Lorem Ipsum",
                            description: "2008 Prototype beer, a 4.7% wheat ale with crushed juniper berries and citrus peel.",
                            imageURL: "https://images.punkapi.com/v2/25.png")

        let cell = BeerCell(style: .default, reuseIdentifier: "BeerCell")
        cell.configure(beer: mockBeer)
        return cell
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

struct BeerCell_Preview: PreviewProvider {
    static var previews: some View {
        BeerCellRepresentable()
    }
}
