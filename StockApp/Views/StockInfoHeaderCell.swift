//
//  StockInfoCell.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/30/20.
//

import UIKit

class StockInfoHeaderCell: UICollectionViewCell {

    static let identifier = "StockInfoCell"

    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()

    let stockChartView: StockChartView = {
        let view = StockChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue

        addSubview(symbolLabel)
        addSubview(stockChartView)

        NSLayoutConstraint.activate([
            symbolLabel.heightAnchor.constraint(equalToConstant: 50),
            symbolLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: stockChartView.topAnchor),

            stockChartView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stockChartView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stockChartView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: StockHeaderCellViewModel) {
        stockChartView.set(viewModel: viewModel)
    }
}
