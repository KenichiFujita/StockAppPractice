//
//  Model.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import Foundation

struct SearchResponse: Decodable {
    let bestMatches: [Company]
}

struct Company: Decodable, Hashable {
    let symbol: String
    let name: String
//    let type: String
//    let region: String
    let marketOpen: String
    let marketClose: String
//    let timeZone: String
//    let currency: String
//    let matchScore: String

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case marketOpen = "5. marketOpen"
        case marketClose = "6. marketClose"
    }
}

struct StockResponse: Decodable {

    var timeSeries: [TimeSeries]? {
        return timeSeriesDaily?.array ?? timeSeries5min?.array ?? []
    }

    let timeSeriesDaily: DecodedArray<TimeSeries>?
    let timeSeries5min: DecodedArray<TimeSeries>?

    enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
        case timeSeries5min = "Time Series (5min)"
    }

}

struct TimeSeries: Decodable {

    let time: String

    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case time

        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        open = try container.decode(String.self, forKey: CodingKeys.open)
        high = try container.decode(String.self, forKey: CodingKeys.high)
        low = try container.decode(String.self, forKey: CodingKeys.low)
        close = try container.decode(String.self, forKey: CodingKeys.close)
        volume = try container.decode(String.self, forKey: CodingKeys.volume)

        time = container.codingPath[1].stringValue
    }

}

struct DecodedArray<T: Decodable>: Decodable {

    var array: [T]

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray: [T] = []

        for key in container.allKeys {
            let decodedObject = try container.decode(T.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }

        array = tempArray
    }
}

private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
