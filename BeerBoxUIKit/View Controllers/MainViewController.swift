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
    private lazy var bannerView = BannerView()
    private lazy var categoryPickerView = CategoryPickerView()
    private lazy var stackBannerAndCategoryView = UIStackView()
    private lazy var tableView = UITableView()
    private lazy var logoStackView = UIStackView()

    private let searchController = UISearchController(searchResultsController: nil)
    var selectedBeerCategory = "Lager"

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
//            await fetchMaltCategory(categoryName: selectedBeerCategory)
            await fetchBeers()
        }

        setStyle()
        setConstraints()
    }

    private func setStyle() {
        view.backgroundColor = Palette.backgroundColor
        navigationItem.searchController = searchController
        navigationItem.titleView = logoStackView
        navigationItem.hidesSearchBarWhenScrolling = false

        setupSearchBar()

        logoStackView.axis = .horizontal
        logoStackView.distribution = .fillEqually
        logoStackView.spacing = 5
        let logoLabel = [setupLogoLabel(label: "Beer", weight: .light, alignmenent: .left),
                         setupLogoLabel(label: "Box", weight: .bold, alignmenent: .right)]
        logoLabel.forEach { logoStackView.addArrangedSubview($0) }

        stackBannerAndCategoryView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackBannerAndCategoryView.isLayoutMarginsRelativeArrangement = true
        stackBannerAndCategoryView.axis = .vertical
        stackBannerAndCategoryView.distribution = .equalSpacing

        setupTableView()
    }

    private func setupLogoLabel(label: String, weight: UIFont.Weight, alignmenent: NSTextAlignment) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.textAlignment = alignmenent
        titleLabel.textColor = Palette.titleColor
        titleLabel.font = .systemFont(ofSize: 24, weight: weight)
        return titleLabel
    }

    private func setupTableView() {
        tableView.register(BeerCell.self, forCellReuseIdentifier: "BeerCell")
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Palette.primaryColor
        searchController.searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .highlighted)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.delegate = self
        definesPresentationContext = false

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

    private func setConstraints() {
        view.addConstrainedSubview(tableView, stackBannerAndCategoryView)

        stackBannerAndCategoryView.addArrangedSubview(bannerView)
        stackBannerAndCategoryView.addArrangedSubview(categoryPickerView)

        NSLayoutConstraint.activate([
            bannerView.heightAnchor.constraint(equalToConstant: 70),
            stackBannerAndCategoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackBannerAndCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackBannerAndCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: stackBannerAndCategoryView.bottomAnchor, constant: 5)
        ])
    }

    private func fetchMoreBeers(page: Int) async {
        await beerViewModel.fetchMoreBeers(url: URL(string: "https://api.punkapi.com/v2/beers?page=\(page)")!)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print(beerViewModel.beers)
    }

    private func fetchBeers() async {
        await beerViewModel.fetchBeers(url: URL(string: "https://api.punkapi.com/v2/beers")!)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print(beerViewModel.beers)
    }

    private func fetchMaltCategory(categoryName: String) async {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?malt=\(categoryName)") else {
            return
        }
        await beerViewModel.fetchBeers(url: url)
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

    // MARK: RESET PAGE

    func presentBottomSheet(indexPath: IndexPath) {
        let beerDetailVC = BeerDetailViewController()
        beerDetailVC.sheetPresentationController?.delegate = self
        beerDetailVC.titleDetail = beerViewModel.beers[indexPath.row].name
        beerDetailVC.descriptionDetail = beerViewModel.beers[indexPath.row].description
        beerDetailVC.taglineDetail = beerViewModel.beers[indexPath.row].tagline
        beerDetailVC.imageUrl = beerViewModel.beers[indexPath.row].imageURL
        beerDetailVC.modalPresentationStyle = .pageSheet
        if let sheet = beerDetailVC.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    context.maximumDetentValue * 0.45
                }
            ]
            sheet.preferredCornerRadius = 18
        }
        view.alpha = 0.5
        navigationController?.navigationBar.alpha = 0.5
        present(beerDetailVC, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as? BeerCell else {
            fatalError("BeerCell missing")
        }

        let count = beerViewModel.beers.count
        if count > 1 {
            let lastElement = count - 1
            if indexPath.row == lastElement, !beerViewModel.isLastPage {
                // call get api for next page
                beerViewModel.page += 1
                Task {
                    await fetchMoreBeers(page: beerViewModel.page)
                }
                print("FETCHING PAGE NUMBER: ", beerViewModel.page)
            } else if beerViewModel.isLastPage {
                beerViewModel.page = 1
            }
        }

        let beer = beerViewModel.beers[indexPath.row]
        cell.configure(beer: beer)
        cell.showInfo = { [weak self] in
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
}

extension MainViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_: UIPresentationController) {
        view.alpha = 1.0
        navigationController?.navigationBar.alpha = 1
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if tableView.contentOffset.y != .zero {
            tableView.setContentOffset(.zero, animated: true)
        }

        guard let query = searchController.searchBar.text else {
            return
        }

        if !query.isEmpty {
            Task {
                await searchBeer(beerName: query.trimmingCharacters(in: .whitespaces))
            }
        }
    }

    /* Hide banner and category on search */
    func searchBarTextDidBeginEditing(_: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryPickerView.isHidden = true
            self.categoryPickerView.alpha = 0
            self.bannerView.isHidden = true
            self.bannerView.alpha = 0
        })
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryPickerView.isHidden = false
            self.categoryPickerView.alpha = 1
            self.bannerView.isHidden = false
            self.bannerView.alpha = 1
        })
        Task {
            await fetchMaltCategory(categoryName: selectedBeerCategory)
        }
    }
}
