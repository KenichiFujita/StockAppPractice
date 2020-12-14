//
//  StockViewController.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import UIKit

class StockViewController: UIViewController {

    let viewModel: StockViewModelType
    let dataSource: StockViewDataSource = StockViewDataSource()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StockInfoCell.self, forCellWithReuseIdentifier: StockInfoCell.identifier)
        return collectionView
    }()

    init(_ company: Company) {
        self.viewModel = StockViewModel(company)
        dataSource.company = company
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.addSubview(collectionView)

        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        viewModel.inputs.viewDidLoad()
    }

    private func bind() {
        viewModel.outputs.reloadData = { [weak self] items in
            if let viewController = self {
                viewController.dataSource.items = items
//                viewController.dataSource.stocks[intervalAndTimeSeries.0] = intervalAndTimeSeries.1
            }
        }
    }
    
}

extension StockViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

}
