//
//  ExtensionUIView.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 04/03/23.
//

import UIKit

extension UIView {
    func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    func addConstrainedSubview(_ view: UIView...) {
        view.forEach { view in
            addConstrainedSubview(view)
        }
    }
}
