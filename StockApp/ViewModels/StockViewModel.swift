//
//  StockViewModel.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import Foundation

enum StockViewModelItemType {
    case companyInfo
    case timeInterval
    case timeSeries
    case stockInfo
}

protocol StockViewModelItem {
    var type: StockViewModelItemType { get }
    var rowCount: Int { get }
}

extension StockViewModelItem {
    var rowCount: Int {
        return 1
    }
}

protocol StockViewModelType: AnyObject {
    var inputs: StockViewModelInputs { get }
    var outputs: StockViewModelOutputs { get }
}

protocol StockViewModelInputs: AnyObject {
    func viewDidLoad()
    func intervalButtonDidTap()
}

protocol StockViewModelOutputs: AnyObject{
//    var reloadData: (((Interval, [TimeSeries])) -> Void) { get set }
    var reloadData: ([StockViewModelItem]) -> Void { get set }
}

class StockViewModel: StockViewModelType, StockViewModelInputs, StockViewModelOutputs {

    private let webService: WebService
    var inputs: StockViewModelInputs { return self }
    var outputs: StockViewModelOutputs { return self }

    let company: Company

    init(_ company: Company, webService: WebService = WebService()) {
        self.webService = webService
        self.company = company
    }

    func viewDidLoad() {
        fetchTimeSeries(interval: .daily)

    }

    func intervalButtonDidTap() {
        
    }

    private func fetchTimeSeries(interval: Interval) {

        webService.stock(company.symbol, interval: interval, completionHandler: { result in
            if case .success(let timeSeries) = result {
                var items: [StockViewModelItem] = []
                items.append(StockViewModelCompanyInfoItem(name: self.company.name,
                                                           symbol: self.company.symbol))
                self.reloadData(items)

//                self.reloadData((interval, timeSeries))
            }
        })

    }

//    var reloadData: (((Interval, [TimeSeries])) -> Void) = { _ in }
    var reloadData: ([StockViewModelItem]) -> Void = { _ in }

}


class StockViewModelCompanyInfoItem: StockViewModelItem {

    var type: StockViewModelItemType {
        return .companyInfo
    }

    let name: String
    let symbol: String

    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }

}
