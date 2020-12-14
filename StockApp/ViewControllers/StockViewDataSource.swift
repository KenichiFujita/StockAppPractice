//
//  StockViewDataSource.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import UIKit

class StockViewDataSource: NSObject, UICollectionViewDataSource {

//    var stocks: [Interval: [TimeSeries]] = [:]
    var company: Company?
    var items: [StockViewModelItem] = []

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].rowCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .companyInfo:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockInfoCell.identifier, for: indexPath) as? StockInfoCell {
                
                return cell
            }
        case .timeInterval:
            return UICollectionViewCell()
        case .timeSeries:
            return UICollectionViewCell()
        case .stockInfo:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }

}
