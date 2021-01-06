//
//  StockViewController.swift
//  StockApp
//
//  Created by Kenichi Fujita on 11/22/20.
//

import UIKit

class StockViewController: UIViewController {

//    let viewModel: StockViewModelType
    let dataSource: StockViewDataSource

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StockInfoHeaderCell.self, forCellWithReuseIdentifier: StockInfoHeaderCell.identifier)
        return collectionView
    }()

    init(_ company: Company) {
//        self.viewModel = StockViewModel(company)
        dataSource = StockViewDataSource(company: company)
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

//        bind()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
//        viewModel.inputs.viewDidLoad()
    }

//    private func bind() {
//        viewModel.outputs.reloadData = { [weak self] items in
//            if let viewController = self {
//                viewController.dataSource.timeSerieses = items
//                    viewController.collectionView.reloadData()
//            }
//        }
//    }
    
}

extension StockViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }

}
