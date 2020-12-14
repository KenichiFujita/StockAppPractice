//
//  StockInfoCell.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/30/20.
//

import UIKit

class StockInfoCell: UICollectionViewCell {

    static let identifier = "StockInfoCell"

    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "stockInfoCell"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
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

    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
    }

}

