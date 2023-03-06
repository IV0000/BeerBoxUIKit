//
//  BeerListViewModel.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class BeerListViewModel {
    private(set) var beers: Beers = []
    var page: Int = 1
    var isLastPage: Bool = false

    func fetchBeers(url: URL) async {
        do {
            let beers = try await Webservice().getBeers(url: url)
            self.beers = beers.sorted(by: { $0.name < $1.name })

        } catch {
            print(error)
        }
    }

    func fetchMoreBeers(url: URL) async {
        do {
            let beers = try await Webservice().getBeers(url: url)
            if beers == [] {
                isLastPage = true
            }
            self.beers.append(contentsOf: beers)

        } catch {
            print(error)
        }
    }
}

// TODO: REMOVE
// struct BeerViewModel {
//    private let beer: Beer
//
//    init(beer: Beer) {
//        self.beer = beer
//    }
//
//
//    var name : String {
//        beer.name
//    }
//    var tagline : String {
//        beer.tagline
//    }
//    var description: String {
//        beer.description
//    }
//
//    var image: UIImage {
//        UIImage(
//    }
// }
