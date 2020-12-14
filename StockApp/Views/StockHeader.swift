//
//  StockHeader.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import UIKit

class StockHeader: UICollectionReusableView {

    static let identifier = "stockHeader"

    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(symbolLabel)

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

}
