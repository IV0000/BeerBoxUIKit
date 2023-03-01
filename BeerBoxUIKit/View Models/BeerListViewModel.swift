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
    
    func fetchBeers(url: URL) async {
        do {
            let beers = try await Webservice().getBeers(url: url)
            self.beers = beers
        } catch {
            print(error)
        }
    }
}


// TODO: REMOVE
//struct BeerViewModel {
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
//}


