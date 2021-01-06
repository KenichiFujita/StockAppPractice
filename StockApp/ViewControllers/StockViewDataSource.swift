//
//  StockViewDataSource.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import UIKit

class StockViewDataSource: NSObject, UICollectionViewDataSource {

    let company: Company

    init(company: Company) {
        self.company = company
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockInfoHeaderCell.identifier, for: indexPath) as? StockInfoHeaderCell {
            configure(cell)
            return cell
        }

        return UICollectionViewCell()
    }

    private func configure(_ cell: StockInfoHeaderCell) {
        cell.symbolLabel.text = company.name
        let viewModel = StockHeaderCellViewModel(company: company)
        cell.set(viewModel: viewModel)
    }

}
