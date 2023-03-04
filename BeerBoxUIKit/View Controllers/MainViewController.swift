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

    let searchController = UISearchController(searchResultsController: nil)
    var selectedBeerCategory = "Lager"
    var isSearchActive = false

    lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 5
        [self.titleLabelBeer,
         self.titleLabelBox].forEach { titleStackView.addArrangedSubview($0) }
        return titleStackView
    }()

    lazy var categoryButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        return button
    }()

    var xOffset: CGFloat = 10

    lazy var categoryButtonsStack: UIStackView = {
        // TODO: USE DIFFERENT CATEGORIES
        let typeOfMalts = ["Lager", "2", "Munich", "Pale", "1"]
        let stackView = UIStackView()
        stackView.spacing = 8
        for (index, value) in typeOfMalts.enumerated() {
            let button = UIButton()
            var config = UIButton.Configuration.filled()
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: 14)
            button.tag = index
            if button.tag == 0 {
                config.baseBackgroundColor = Palette.primaryColor
                config.baseForegroundColor = Palette.darkTextColor
            } else {
                config.baseBackgroundColor = Palette.searchBarColor
                config.baseForegroundColor = Palette.textColor
            }
            config.cornerStyle = .capsule
            config.attributedTitle = AttributedString("\(value)", attributes: container)
            button.configuration = config
            button.frame = CGRect(x: xOffset, y: 10, width: 70, height: 30)
            xOffset = xOffset + CGFloat(10) + button.frame.size.width

            button.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.touchUpInside)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }()

    lazy var categoryHorizontalScroll: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 120, width: view.bounds.width, height: 70))
        scroll.showsHorizontalScrollIndicator = false
        scroll.addSubview(categoryButtonsStack)
        categoryButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        categoryButtonsStack.centerYAnchor.constraint(equalTo: scroll.centerYAnchor).isActive = true
        scroll.contentSize = CGSize(width: xOffset, height: 1.0)
        return scroll
    }()

    lazy var stackBannerCategory: UIStackView = {
        let stack = UIStackView()
        // TODO: FIX MARGINS
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.distribution = .equalSpacing

        stack.addArrangedSubview(bannerView)
        stack.addArrangedSubview(categoryHorizontalScroll)
        return stack
    }()

    @objc
    func buttonTapped(sender: UIButton) {
        categoryButtonsStack.subviews.forEach {
            ($0 as? UIButton)?.isSelected = false
            ($0 as? UIButton)?.configuration?.baseBackgroundColor = Palette.searchBarColor
            ($0 as? UIButton)?.configuration?.baseForegroundColor = Palette.textColor
        }
        sender.isSelected = true
        sender.configuration?.baseBackgroundColor = Palette.bannerColor
        sender.configuration?.baseForegroundColor = Palette.darkTextColor
        selectedBeerCategory = (sender.titleLabel?.text)!
        Task {
            print("Debug", selectedBeerCategory)
            await fetchMaltCategory(categoryName: selectedBeerCategory)
        }
        tableView.setContentOffset(.zero, animated: true)
    }

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
//            await fetchMaltCategory(categoryName: selectedBeerCategory)
            await fetchBeers(page: 1)
        }

        navigationItem.searchController = searchController
        navigationItem.titleView = titleStackView
        navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = Palette.backgroundColor
        view.addSubview(tableView)
        view.addSubview(stackBannerCategory)
        setupConstraints()
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

    private func setupConstraints() {
        stackBannerCategory.translatesAutoresizingMaskIntoConstraints = false
        stackBannerCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackBannerCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackBannerCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: stackBannerCategory.bottomAnchor, constant: 10).isActive = true

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bannerView.topAnchor.constraint(equalTo: stackBannerCategory.topAnchor).isActive = true
//        bannerView.leadingAnchor.constraint(equalTo: stackBannerCategory.leadingAnchor, constant: 15).isActive = true
//        bannerView.trailingAnchor.constraint(equalTo: stackBannerCategory.trailingAnchor, constant: -15).isActive = true

        categoryHorizontalScroll.translatesAutoresizingMaskIntoConstraints = false
        categoryHorizontalScroll.heightAnchor.constraint(equalToConstant: 60).isActive = true
        categoryHorizontalScroll.widthAnchor.constraint(equalTo: bannerView.widthAnchor).isActive = true
        categoryHorizontalScroll.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        categoryHorizontalScroll.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor).isActive = true
        categoryHorizontalScroll.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor).isActive = true
    }

    private func fetchBeers(page: Int) async {
        await beerViewModel.fetchBeers(url: URL(string: "https://api.punkapi.com/v2/beers?page=\(page)")!)
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
                },
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
            if indexPath.row == lastElement {
                // call get api for next page
                beerViewModel.page += 1
                Task {
                    await fetchBeers(page: beerViewModel.page)
                }
                print("FETCHING PAGE NUMBER: ", beerViewModel.page)
            }
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
            self.categoryHorizontalScroll.isHidden = true
            self.categoryHorizontalScroll.alpha = 0
            self.bannerView.isHidden = true
            self.bannerView.alpha = 0
        })
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryHorizontalScroll.isHidden = false
            self.categoryHorizontalScroll.alpha = 1
            self.bannerView.isHidden = false
            self.bannerView.alpha = 1
        })
        Task {
            await fetchMaltCategory(categoryName: selectedBeerCategory)
        }
    }
}
