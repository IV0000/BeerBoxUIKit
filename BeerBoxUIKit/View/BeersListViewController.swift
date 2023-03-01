//
//  BeersListViewController.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    private let beerViewModel = BeerListViewModel()
    
    lazy var titleStackView : UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 5
        [self.titleLabelBeer,
         self.titleLabelBox].forEach { titleStackView.addArrangedSubview($0) }
        return titleStackView
    }()
    
    lazy var bannerView : UIView =  {
        let bannerView = UIView()
        bannerView.backgroundColor = Palette.bannerColor
        bannerView.layer.cornerRadius = 12
        return bannerView
    }()
    
    lazy var bannerImage: UIImageView =  {
       let image = UIImage(named: "banner")
        return UIImageView(image: image)
    }()
    
    lazy var bannerTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Weekend offers"
        titleLabel.textAlignment = .left
        titleLabel.textColor = Palette.darkTextColor
        titleLabel.font = .systemFont(ofSize: 16,weight: .bold)
        return titleLabel
    }()
    
    lazy var bannerDescriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Free shipping on orders over 60$"
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = Palette.darkTextColor
        descriptionLabel.font = .systemFont(ofSize: 16,weight: .regular)
        return descriptionLabel
    }()

    
    lazy var titleLabelBeer : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Beer"
        titleLabel.textAlignment = .right
        titleLabel.textColor = Palette.titleColor
        titleLabel.font = .systemFont(ofSize: 24,weight: .light)
        return titleLabel
    }()
    
    lazy var titleLabelBox : UILabel = {
        let titleLable = UILabel()
        titleLable.text = "Box"
        titleLable.textAlignment = .left
        titleLable.textColor = Palette.titleColor
        titleLable.font = .systemFont(ofSize: 24,weight: .bold)
        return titleLable
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(BeerCell.self, forCellReuseIdentifier: "BeerCell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchBeers()
        }
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = Palette.backgroundColor
        view.addSubview(titleStackView)
        view.addSubview(bannerView)
        bannerView.addSubview(bannerTitleLabel)
        bannerView.addSubview(bannerDescriptionLabel)
        bannerView.addSubview(bannerImage)
        view.addSubview(tableView)
        setupConstraints()
       
    }
    
    private func setupConstraints() {
        
        let guide = self.view.safeAreaLayoutGuide
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bannerView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor,constant: 10).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15).isActive = true
        
        bannerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerTitleLabel.topAnchor.constraint(equalTo: bannerView.topAnchor,constant: 15).isActive = true
        bannerTitleLabel.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor,constant: 15).isActive = true
        
        bannerDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerDescriptionLabel.topAnchor.constraint(equalTo: bannerTitleLabel.bottomAnchor).isActive = true
        bannerDescriptionLabel.leadingAnchor.constraint(equalTo: bannerTitleLabel.leadingAnchor).isActive = true
        
        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        bannerImage.contentMode = .scaleToFill
        bannerImage.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true
        bannerImage.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor,constant: -15).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: bannerView.bottomAnchor,constant: 10).isActive = true
    }
  
    private func fetchBeers() async {
        await  beerViewModel.fetchBeers(url: URL(string: "https://api.punkapi.com/v2/beers")!)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print(beerViewModel.beers)
    }
}

extension MainViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as? BeerCell else {
            fatalError("BeerCell missing")
        }
        
        let beer = beerViewModel.beers[indexPath.row]
        cell.configure(beer: beer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beerDetailVC = BeerDetailViewController()
        beerDetailVC.titleLabel = beerViewModel.beers[indexPath.row].name
        beerDetailVC.descriptionLabel = beerViewModel.beers[indexPath.row].description
        beerDetailVC.taglineLabel = beerViewModel.beers[indexPath.row].tagline
        beerDetailVC.imageUrl = beerViewModel.beers[indexPath.row].imageURL
        beerDetailVC.modalPresentationStyle = .pageSheet
        if let sheet = beerDetailVC.sheetPresentationController {
               sheet.detents = [.medium()]
        }
        self.present( beerDetailVC,  animated: true,  completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        beerViewModel.beers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
