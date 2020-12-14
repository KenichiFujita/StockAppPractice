//
//  DiffableDataSource.swift
//  StockApp
//
//  Created by Kenichi Fujita on 12/4/20.
//

import UIKit

class SearchViewDataSource: UITableViewDiffableDataSource<Section, Company> {

    var companies: [Company] = []

    init(tableView: UITableView) {
        super.init(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: searchViewCellIdentifier, for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(model.symbol) - \(model.name)"
            cell.contentConfiguration = configuration
            return cell
        }
    }

    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Company>()
        snapshot.appendSections([.first])
        snapshot.appendItems(companies)
        apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func configure(_ cell: UITableViewCell, with company: Company) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(company.symbol) - \(company.name)"
        cell.contentConfiguration = configuration
    }
}
