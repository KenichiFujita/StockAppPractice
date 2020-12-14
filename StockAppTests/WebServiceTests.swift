//
//  WebServiceTests.swift
//  StockAppTests
//
//  Created by Kenichi Fujita on 11/21/20.
//

import XCTest
@testable import StockApp

class WebServiceTests: XCTestCase {

    var webService: WebService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        webService = WebService(session: session)
    }

    override func tearDownWithError() throws {
        webService = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testSearchCompanies() {

    }

    func testStock() {
        let path = Bundle.main.path(forResource: "TimeSeriesData", ofType: "json")!
        let jsonData = try! String(contentsOfFile: path).data(using: .utf8)
        MockURLProtocol.stubResponseData = jsonData
        let expectation = XCTestExpectation()

        webService.stock("IBM", interval: .sixtyMin, completionHandler: { result in
            switch result {
            case .success(let timeSeries) :
                print(timeSeries)
                expectation.fulfill()
            case .failure(_ ) :
                XCTFail()
            }
        })
        wait(for: [expectation], timeout: 2)
    }

    func testNetwork() {
        let realWebService = WebService()
        let expectation = XCTestExpectation()

        realWebService.stock("IBM", interval: .fiveMin, completionHandler: { result in
            switch result {
            case .success(let timeSeries):
                print(timeSeries)
                expectation.fulfill()
            case .failure(_ ):
                XCTFail()
            }
        })
        wait(for: [expectation], timeout: 5)
    }
}
