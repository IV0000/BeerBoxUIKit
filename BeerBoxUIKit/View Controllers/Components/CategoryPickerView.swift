//
//  CategoryPickerView.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 06/03/23.
//

import UIKit

class CategoryPickerView: UIView {
    private let categoryButtonsStack = UIStackView()
    private let categoryHorizontalScroll = UIScrollView()

    var selectCategory: (() -> Void) = {}

    var buttonOffsetX: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraints()
        setStyle()
    }

    func setStyle() {
        categoryButtonsStack.spacing = 8
        setScrollbarStyle()
    }

    private func setScrollbarStyle() {
        categoryHorizontalScroll.frame = CGRect(x: 0, y: 0, width: 400, height: 70)
        categoryHorizontalScroll.showsHorizontalScrollIndicator = false
        categoryHorizontalScroll.contentSize = CGSize(width: buttonOffsetX, height: 1.0)
    }

    func categoryButton(label: String, index: Int) -> UIButton {
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

    func listOfButtons() -> [UIButton] {
        var listOfButtons: [UIButton] = []
        for (index, value) in Categories.allCases.enumerated() {
            let button = categoryButton(label: value.rawValue, index: index)
//            button.addTarget(self, action: #selector(selectCategory), for: UIControl.Event.touchUpInside)
            listOfButtons.append(button)
        }
        return listOfButtons
    }

    private func setConstraints() {
        listOfButtons().forEach { categoryButtonsStack.addArrangedSubview($0) }
        categoryHorizontalScroll.addConstrainedSubview(categoryButtonsStack)
        addSubview(categoryHorizontalScroll)

        heightAnchor.constraint(equalToConstant: 70).isActive = true
        categoryButtonsStack.centerYAnchor.constraint(equalTo: categoryHorizontalScroll.centerYAnchor).isActive = true
    }

//
//    @objc
//    func selectCategory(sender: UIButton) {
//        categoryButtonsStack.subviews.forEach {
//            ($0 as? UIButton)?.isSelected = false
//            ($0 as? UIButton)?.backgroundColor = Palette.searchBarColor
//            ($0 as? UIButton)?.setTitleColor(Palette.textColor, for: .normal)
//        }
//        sender.isSelected = true
//        sender.backgroundColor = Palette.bannerColor
//        sender.setTitleColor(Palette.darkTextColor, for: .normal)
//        selectedBeerCategory = (sender.titleLabel?.text)!
//        Task {
//            print("Debug", selectedBeerCategory)
//            await fetchMaltCategory(categoryName: selectedBeerCategory)
//        }
//        tableView.setContentOffset(.zero, animated: true)
//    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
