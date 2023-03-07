//
//  BeerListViewModel.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class BeerViewModel {
    private(set) var beers: Beers = []

    var isLastPage: Bool = false
    var cleanData: Bool = false
    var page: Int = 1

    func fetchBeers(url: URL) async {
        do {
            let beers = try await Webservice().getBeers(url: url)

            if cleanData {
                self.beers = []
                cleanData = false
            }

            if self.beers.isEmpty {
                isLastPage = false
                self.beers = beers
                page = 1
            } else {
                guard beers != [] else {
                    isLastPage = true
                    return
                }
                self.beers.append(contentsOf: beers)
            }
        } catch {
            print(error)
        }
    }
}

enum BeerCategories: CaseIterable {
    case lager
    case wheat
    case pale
    case chocolate
    case rye

    var label: String {
        switch self {
        case .lager:
            return "Lager"
        case .rye:
            return "Rye"
        case .wheat:
            return "Wheat"
        case .pale:
            return "Pale"
        case .chocolate:
            return "Chocolate"
        }
    }
}
