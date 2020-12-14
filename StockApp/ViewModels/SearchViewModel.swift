//
//  SearchViewModel.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import Foundation

enum Section {
    case first
}

protocol SearchViewModelType: AnyObject {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

protocol SearchViewModelInputs: AnyObject {
    func viewDidLoad()
    func searchTextDidChange(text: String)
}

protocol SearchViewModelOutputs: AnyObject {
    var reloadData: (([Company]) -> Void) { get set }
}

class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {

    private let webService: WebService

    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }

    init(webService: WebService = WebService()) {
        self.webService = webService
    }

    func viewDidLoad() {

    }

    func searchTextDidChange(text: String) {
        print("test")
        if text == "" {
            reloadData([])
            return
        }
        webService.search(with: text, completionHandler: { result in
            switch result {
            case .success(let companies):
                self.reloadData(companies)
            case .failure(let error):
                print(error.localizedDescription)
                self.reloadData([])
            }
        })
    }

    var reloadData: (([Company]) -> Void) = { _ in }

}
