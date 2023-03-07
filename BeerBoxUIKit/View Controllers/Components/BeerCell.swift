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
    var showInfo: (() -> Void) = {}
    private let titleLabel = UILabel()
    private let taglineLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let moreInfoButton = UIButton()
    private let beerImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pressedAction(_: UIButton) {
        showInfo()
    }

    func configure(beer: Beer) {
        setStyle(beer: beer)
        setConstraints()
    }

    func setStyle(beer: Beer) {
        contentView.backgroundColor = Palette.backgroundColor

        titleLabel.text = beer.name
        titleLabel.textColor = Palette.titleColor

        taglineLabel.textColor = Palette.textColor
        taglineLabel.text = beer.tagline

        descriptionLabel.textColor = Palette.textColor
        descriptionLabel.text = beer.description
        descriptionLabel.numberOfLines = 2

        moreInfoButton.setTitle("MORE INFO", for: .normal)
        moreInfoButton.setTitleColor(Palette.primaryColor, for: .normal)
        moreInfoButton.setTitleColor(Palette.primaryColor.withAlphaComponent(0.5), for: .highlighted)
        moreInfoButton.titleLabel?.font = .systemFont(ofSize: 16)
        moreInfoButton.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)

        beerImage.downloaded(from: beer.imageURL, contentMode: .scaleToFill)
    }

    func setConstraints() {
        addConstrainedSubview(beerImage,
                              titleLabel,
                              taglineLabel,
                              descriptionLabel,
                              moreInfoButton)

        NSLayoutConstraint.activate([
            beerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            beerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            beerImage.widthAnchor.constraint(equalToConstant: 25),
            beerImage.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: beerImage.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),

            taglineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            moreInfoButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            moreInfoButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: -5),
        ])
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
