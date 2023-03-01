//
//  BeerDetailViewController.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 01/03/23.
//

import Foundation
import UIKit

class BeerDetailViewController : UIViewController {
    
    var titleLabel: String?
    var taglineLabel: String?
    var descriptionLabel: String?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.backgroundColor
    }
    
}
