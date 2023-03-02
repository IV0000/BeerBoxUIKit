//
//  MainViewController.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    private let beerViewModel = BeerListViewModel()

    let searchController = UISearchController(searchResultsController: nil)

    lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 5
        [self.titleLabelBeer,
         self.titleLabelBox].forEach { titleStackView.addArrangedSubview($0) }
        return titleStackView
    }()

    lazy var bannerView: UIView = {
        let bannerView = UIView()
        bannerView.backgroundColor = Palette.bannerColor
        bannerView.layer.cornerRadius = 12
        return bannerView
    }()

    lazy var bannerImage: UIImageView = {
        let image = UIImage(named: "banner")
        return UIImageView(image: image)
    }()

    lazy var bannerTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Weekend offers"
        titleLabel.textAlignment = .left
        titleLabel.textColor = Palette.darkTextColor
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        return titleLabel
    }()

    lazy var bannerDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Free shipping on orders over 60$"
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = Palette.darkTextColor
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        return descriptionLabel
    }()

    lazy var titleLabelBeer: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Beer"
        titleLabel.textAlignment = .right
        titleLabel.textColor = Palette.titleColor
        titleLabel.font = .systemFont(ofSize: 24, weight: .light)
        return titleLabel
    }()

    lazy var titleLabelBox: UILabel = {
        let titleLable = UILabel()
        titleLable.text = "Box"
        titleLable.textAlignment = .left
        titleLable.textColor = Palette.titleColor
        titleLable.font = .systemFont(ofSize: 24, weight: .bold)
        return titleLable
    }()

    lazy var tableView: UITableView = {
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
        navigationItem.searchController = searchController
        navigationItem.titleView = titleStackView
        setupSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = Palette.backgroundColor
        view.addSubview(bannerView)
        bannerView.addSubview(bannerTitleLabel)
        bannerView.addSubview(bannerDescriptionLabel)
        bannerView.addSubview(bannerImage)
        view.addSubview(tableView)
        setupConstraints()
    }

    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Palette.primaryColor
        searchController.searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .highlighted)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true

        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = Palette.textColor
            textfield.backgroundColor = Palette.searchBarColor
            textfield.layer.cornerRadius = 10
            textfield.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: Palette.textColor]
            )

            if let clearButton = textfield.value(forKey: "_clearButton") as? UIButton {
                let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
                clearButton.setImage(templateImage, for: .normal)
                clearButton.tintColor = Palette.primaryColor
            }

            if let searchIcon = textfield.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.tintColor = Palette.textColor
            }
        }

        searchController.searchResultsUpdater = self
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bannerView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true

        bannerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerTitleLabel.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 15).isActive = true
        bannerTitleLabel.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 15).isActive = true

        bannerDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerDescriptionLabel.topAnchor.constraint(equalTo: bannerTitleLabel.bottomAnchor).isActive = true
        bannerDescriptionLabel.leadingAnchor.constraint(equalTo: bannerTitleLabel.leadingAnchor).isActive = true

        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        bannerImage.contentMode = .scaleToFill
        bannerImage.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true
        bannerImage.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: -15).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 10).isActive = true
    }

    private func fetchBeers() async {
        await beerViewModel.fetchBeers(url: URL(string: "https://api.punkapi.com/v2/beers")!)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print(beerViewModel.beers)
    }

    private func searchBeer(beerName: String) async {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?beer_name=\(beerName)") else {
            return
        }

        await beerViewModel.fetchBeers(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print(beerViewModel.beers)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as? BeerCell else {
            fatalError("BeerCell missing")
        }

        let beer = beerViewModel.beers[indexPath.row]
        cell.configure(beer: beer)
        cell.buttonPressed = { [weak self] in
            self?.presentBottomSheet(indexPath: indexPath)
        }
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        beerViewModel.beers.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 130
    }

    func presentBottomSheet(indexPath: IndexPath) {
        let beerDetailVC = BeerDetailViewController()
        // TODO: change bg color to darker
        beerDetailVC.titleDetail = beerViewModel.beers[indexPath.row].name
        beerDetailVC.descriptionDetail = beerViewModel.beers[indexPath.row].description
        beerDetailVC.taglineDetail = beerViewModel.beers[indexPath.row].tagline
        beerDetailVC.imageUrl = beerViewModel.beers[indexPath.row].imageURL
        beerDetailVC.modalPresentationStyle = .pageSheet
        if let sheet = beerDetailVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 18
        }
        present(beerDetailVC, animated: true, completion: nil)
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }
        if query.isEmpty {
            Task {
                await fetchBeers()
            }
        } else {
            Task {
                await searchBeer(beerName: query.trimmingCharacters(in: .whitespaces))
            }
        }
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        Task {
            await fetchBeers()
        }
    }
}
