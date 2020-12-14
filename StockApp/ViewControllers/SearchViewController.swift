//
//  ViewController.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/21/20.
//

import UIKit

let searchViewCellIdentifier = "searchViewCell"

class SearchViewController: UIViewController {

    let viewModel: SearchViewModelType
    var dataSource: SearchViewDataSource?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchViewCellIdentifier)
        return tableView
    }()

    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    init(viewModel: SearchViewModelType = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.addSubview(tableView)
        navigationItem.searchController = searchController

        tableView.frame = view.bounds

        let width: CGFloat = 240.0
        let height: CGFloat = 160.0

        let demoView = DemoView(frame: CGRect(x: view.frame.size.width/2 - width/2,
                                              y: view.frame.size.height/2 - height/2,
                                              width: width,
                                              height: height))
        view.addSubview(demoView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        tableView.delegate = self
        searchController.searchBar.delegate = self
        viewModel.inputs.viewDidLoad()

        dataSource = SearchViewDataSource(tableView: tableView)
    }

    private func bind() {
        viewModel.outputs.reloadData = { [weak self] companies in
            if let viewController = self,
               let dataSource = viewController.dataSource {
                dataSource.companies = companies
                dataSource.updateDataSource()
            }
        }
    }

}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let company = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let viewController = StockViewController(company)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputs.searchTextDidChange(text: searchText)
    }

}

class DemoView: UIView {

    var path: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        simpleShapeLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createRect() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 10, y: frame.height - 10))
        path.addLine(to: CGPoint(x: frame.width - 10, y: frame.height - 10))
        path.addLine(to: CGPoint(x: frame.width - 10, y: 10))
        path.close()
    }

    func simpleShapeLayer() {
        createRect()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        layer.addSublayer(shapeLayer)
    }
}
