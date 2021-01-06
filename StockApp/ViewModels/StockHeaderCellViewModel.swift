//
//  StockHeaderCellViewModel.swift
//  StockApp
//
//  Created by Kenichi Fujita on 1/6/21.
//

import UIKit

class StockHeaderCellViewModel {

    let webService: WebService
    let company: Company
    var timeSerieses: [TimeSeries] = []
    var highestPrice: CGFloat = 0
    var lowestPrice: CGFloat = 0
    var marketOpenTime: Date? = Date.mostRecentWeekdayDate(hour: 9, minute: 30)
    var marketCloseTime: Date? = Date.mostRecentWeekdayDate(hour: 16, minute: 0)

    var reload: (StockHeaderCellModel) -> Void = { _ in }

    init(webService: WebService = WebService(), company: Company) {
        self.webService = webService
        self.company = company
        webService.stock(company.symbol,
                         interval: .fiveMin,
                         completionHandler: { result in
            if case .success(let timeSerieses) = result {

                guard let openToday = self.marketOpenTime,
                      let closeToday = self.marketCloseTime else {
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let todayTimeSerieses = timeSerieses.filter { timeSeries in
                    let time = dateFormatter.date(from: timeSeries.time)
                    if let time = time, time >= openToday, time <= closeToday {
                        return true
                    }
                    return false
                }.sorted {
                    $0.time < $1.time
                }

                let openPrices = todayTimeSerieses.compactMap { $0.open }
                guard let highestString = openPrices.max(),
                      let highest = Float(highestString),
                      let lowestString = openPrices.min(),
                      let lowest = Float(lowestString) else {
                    return
                }

                let stockHeaderCellModel = StockHeaderCellModel(timeSerieses: todayTimeSerieses, highestPrice: CGFloat(highest), lowestPrice: CGFloat(lowest), marketOpenTime: openToday, marketCloseTime: closeToday)
                self.reload(stockHeaderCellModel)

            }
        })
    }

}

struct StockHeaderCellModel {
    let timeSerieses: [TimeSeries]
    let highestPrice: CGFloat
    let lowestPrice: CGFloat
    let marketOpenTime: Date
    let marketCloseTime: Date
}


