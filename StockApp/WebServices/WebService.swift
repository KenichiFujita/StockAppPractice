//
//  WebService.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/21/20.
//

import Foundation

enum AVAPIurl {

    private static let apiKey = "WITTKKQQDRFGOYAK"

    static var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.alphavantage.co"
        urlComponents.path = "/query"
        return urlComponents
    }()

    case search(text: String)
    case timeSeriesIntraday(symbol: String, interval: Interval)

    var url: URL {
        var parameters: [String: String] = [:]
        switch self {
        case .search(text: let text):
            parameters["function"] = "SYMBOL_SEARCH"
            parameters["keywords"] = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        case .timeSeriesIntraday(symbol: let symbol, interval: let interval):
            parameters["symbol"] = symbol
            if interval == .daily {
                parameters["function"] = "TIME_SERIES_DAILY_ADJUSTED"
            } else {
                parameters["function"] = "TIME_SERIES_INTRADAY"
                parameters["interval"] = interval.rawValue
            }
        }
        parameters["apikey"] = AVAPIurl.apiKey
        var urlComponents = AVAPIurl.urlComponents
        urlComponents.setQueryItems(with: parameters)
        guard let url = urlComponents.url else {
            fatalError()
        }
        return url
    }

}

enum StockAppError: Error {
    case requestError, decodingError, unknown, cancel
}

enum Interval: String {

    case oneMin = "1min"
    case fiveMin = "5min"
    case fifteenMin = "15min"
    case thirtyMin = "30min"
    case sixtyMin = "60min"
    case daily

}

class WebService {

    private let session: URLSession
    private var stockSearchTask: URLSessionTask?
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func search(with text: String, completionHandler: @escaping (Result<[Company], StockAppError>) -> Void) {
        fetch(url: AVAPIurl.search(text: text).url, completionHandler: { result in
            switch result {
            case .success(let data):
                do {
                    let searchResponse = try self.decoder.decode(SearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(searchResponse.bestMatches))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.decodingError))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        })
    }

    func stock(_ name: String, interval: Interval, completionHandler: @escaping (Result<[TimeSeries], StockAppError>) -> Void) {
        fetch(url: AVAPIurl.timeSeriesIntraday(symbol: name, interval: interval).url, completionHandler: { result in
            switch result {
            case .success(let data):
                do {
                    let stockResponse = try self.decoder.decode(StockResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(stockResponse.timeSeries ?? []))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.decodingError))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })

    }

    private func fetch(url: URL, completionHandler: @escaping (Result<Data, StockAppError>) -> Void) {
        if let task = stockSearchTask {
            task.cancel()
        }
        stockSearchTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        completionHandler(.failure(.cancel))
                    } else {
                        completionHandler(.failure(.requestError))
                    }
                } else {
                    completionHandler(.failure(.unknown))
                }
                return
            }
            completionHandler(.success(data))
        })
        stockSearchTask?.resume()
    }

}


extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
