//
//  HomeHeaderView.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import Foundation
import UIKit

class HomeHeaderView: UIView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return stackView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.text = "$15,459.27"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()

    let savingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    let savingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Savings"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let savingsValueLabel: UILabel = {
        let label = UILabel()
        label.text = "$100.00"
        label.textColor = .lightGray
        return label
    }()

    let spendingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    let spendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Spending"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let spendingValueLabel: UILabel = {
        let label = UILabel()
        label.text = "$100.00"
        label.textColor = .lightGray
        return label
    }()

    // increment / decrement balance properties
    private let buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalCentering
        return buttonStackView
    }()

    let incrementButton: UIButton = {
        let incrementButton = UIButton(type: .custom)
        incrementButton.setImage(.init(systemName: "plus"), for: .normal)
        incrementButton.backgroundColor = .green
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        return incrementButton
    }()

    let decrementButton: UIButton = {
        let decrementButton = UIButton(type: .custom)
        decrementButton.setImage(.init(systemName: "minus"), for: .normal)
        decrementButton.backgroundColor = .red
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        return decrementButton
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        savingsStackView.addArrangedSubview(savingsLabel)
        savingsStackView.addArrangedSubview(savingsValueLabel)

        spendingStackView.addArrangedSubview(spendingLabel)
        spendingStackView.addArrangedSubview(spendingValueLabel)

        buttonStackView.addArrangedSubview(decrementButton)
        buttonStackView.addArrangedSubview(incrementButton)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(buttonStackView)
        stackView.addArrangedSubview(savingsStackView)
        stackView.addArrangedSubview(spendingStackView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
