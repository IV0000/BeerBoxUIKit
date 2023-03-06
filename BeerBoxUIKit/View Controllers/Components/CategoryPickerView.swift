//
//  CategoryPickerView.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 06/03/23.
//

import UIKit

class CategoryPickerView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
