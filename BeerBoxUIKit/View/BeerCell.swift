//
//  BeerCell.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit
import SwiftUI

class BeerCell : UITableViewCell {
    
    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.titleColor
        return label
    }()
    
    lazy var taglineLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.textColor
        label.numberOfLines = 2
        return label
    }()
    
    lazy var moreInfoLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.primaryColor
        return label
    }()
    
    lazy var beerImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(beer: Beer) {
      
        titleLabel.text = beer.name
        taglineLabel.text = beer.tagline
        descriptionLabel.text = beer.description
        moreInfoLabel.text = "MORE INFO"
        beerImage.downloaded(from: beer.imageURL,contentMode: .scaleToFill)
        contentView.addSubview(titleLabel)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(moreInfoLabel)
        contentView.addSubview(beerImage)
        contentView.backgroundColor = Palette.backgroundColor
       setConstraints()
        
    }
    
    func setConstraints() {
        beerImage.translatesAutoresizingMaskIntoConstraints = false
        beerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15).isActive = true
        beerImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15).isActive = true
        beerImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        beerImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: beerImage.trailingAnchor,constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5).isActive = true

        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor,constant: 15).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -15).isActive = true
        
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        moreInfoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        moreInfoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
    }
    
}

// MARK: Preview
struct BeerCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        
        let mockBeer = Beer(id: 1,
                            name: "Punk Ipa",
                            tagline: "Lorem Ipsum",
                            description: "2008 Prototype beer, a 4.7% wheat ale with crushed juniper berries and citrus peel.",
                            imageURL: "https://images.punkapi.com/v2/25.png")
        
        let cell = BeerCell(style: .default, reuseIdentifier: "BeerCell")
        cell.configure(beer: mockBeer)
        return cell
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct BeerCell_Preview : PreviewProvider {
    static var previews: some View {
        BeerCellRepresentable()
    }
    
}
