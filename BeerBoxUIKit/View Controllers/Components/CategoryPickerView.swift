//
//  CategoryPickerView.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 06/03/23.
//

import UIKit

class CategoryPickerView: UIView {
    private let categoryHorizontalScroll = UIScrollView()
    var categoryButtonsStack = UIStackView()
    var selectCategoryClosure: ((_ button: UIButton) -> Void) = { _ in }
    var buttonOffsetX: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraints()
        setStyle()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        categoryButtonsStack.spacing = 8
        setScrollbarStyle()
    }

    private func setScrollbarStyle() {
        categoryHorizontalScroll.frame = CGRect(x: 0, y: 0, width: 400, height: 70)
        categoryHorizontalScroll.showsHorizontalScrollIndicator = false
        categoryHorizontalScroll.contentSize = CGSize(width: buttonOffsetX, height: 1.0)
    }

    private func categoryButton(label: String, index: Int) -> UIButton {
        let categoryButton = UIButton()
        categoryButton.setTitle(label.capitalized, for: .normal)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 14)
        categoryButton.tag = index
        if categoryButton.tag == 0 {
            categoryButton.backgroundColor = Palette.primaryColor
            categoryButton.setTitleColor(Palette.darkTextColor, for: .normal)
        } else {
            categoryButton.backgroundColor = Palette.searchBarColor
            categoryButton.setTitleColor(Palette.textColor, for: .normal)
        }

        categoryButton.layer.cornerRadius = 15
        categoryButton.layer.cornerCurve = .continuous

        categoryButton.frame = CGRect(x: buttonOffsetX, y: 10, width: 70, height: 30)
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 8,
                                                        left: 15,
                                                        bottom: 8,
                                                        right: 15)
        buttonOffsetX = buttonOffsetX + CGFloat(10) + categoryButton.frame.size.width
        return categoryButton
    }

    private func listOfButtons() -> [UIButton] {
        var listOfButtons: [UIButton] = []
        for (index, value) in BeerCategories.allCases.enumerated() {
            let button = categoryButton(label: value.label, index: index)
            button.addAction(UIAction(handler: { _ in
                self.selectCategoryClosure(button)
            }), for: .touchUpInside)

            listOfButtons.append(button)
        }
        return listOfButtons
    }

    private func setConstraints() {
        listOfButtons().forEach { categoryButtonsStack.addArrangedSubview($0) }
        categoryHorizontalScroll.addConstrainedSubview(categoryButtonsStack)
        addSubview(categoryHorizontalScroll)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            categoryButtonsStack.centerYAnchor.constraint(equalTo: categoryHorizontalScroll.centerYAnchor)
        ])
    }

    func addSelectCategoryButtonTarget(_ target: Any?, action: Selector) {
        for (index, button) in listOfButtons().enumerated() {
            button.tag = index
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        categoryButtonsStack.subviews.forEach {
            ($0 as? UIButton)?.isSelected = false
            ($0 as? UIButton)?.backgroundColor = Palette.searchBarColor
            ($0 as? UIButton)?.setTitleColor(Palette.textColor, for: .normal)
        }
    }
}
