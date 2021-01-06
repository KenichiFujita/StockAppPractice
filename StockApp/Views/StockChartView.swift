//
//  StockChartView.swift
//  StockApp
//
//  Created by Kenichi Fujita on 12/14/20.
//

import UIKit


class StockChartView: UIView {

    private var viewModel: StockHeaderCellViewModel?

    private var stockPriceLineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.lineWidth = 1
        return layer
    }()

    private var stockPriceGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.systemBlue.cgColor, UIColor.clear.cgColor]
        return layer
    }()

    private var stockPriceMaskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = .systemBackground

        stockPriceGradientLayer.mask = stockPriceMaskLayer
        layer.addSublayer(stockPriceGradientLayer)
        layer.addSublayer(stockPriceLineLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: StockHeaderCellViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.reload = { [weak self] model in
            if let view = self {
                view.setPathsToLayers(for: model)
                view.stockPriceGradientLayer.frame = view.bounds
                view.layoutIfNeeded()
            }
        }
    }

    private func setPathsToLayers(for model: StockHeaderCellModel) {
        let linePath = stockPriceLinePath(for: model)
        let fillPath = stockPriceFillPath(stockPriceLinePath: linePath)
        stockPriceLineLayer.path = linePath.cgPath
        stockPriceMaskLayer.path = fillPath.cgPath
    }

    private func stockPriceLinePath(for model: StockHeaderCellModel) -> UIBezierPath {
        let path = UIBezierPath()
        var isFirst = true
        for timeSeries in model.timeSerieses {
            let xCoordinate = CGFloat(timeSeries.time.date.timeIntervalSince(model.marketOpenTime) / 60) * xDivision(open: model.marketOpenTime, close: model.marketCloseTime)
            let yCoordinate = frame.height - ((CGFloat(Float(timeSeries.open) ?? 0) - model.lowestPrice) * yDivision(highestPrice: model.highestPrice, lowestPrice: model.lowestPrice))
            if isFirst {
                path.move(to: CGPoint(x: xCoordinate, y: yCoordinate))
                isFirst = false
            } else {
                path.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
            }
        }
        return path
    }

    private func stockPriceFillPath(stockPriceLinePath: UIBezierPath) -> UIBezierPath {
        let path = stockPriceLinePath.copy() as? UIBezierPath
        guard let fillPath = path else {
            return UIBezierPath()
        }
        fillPath.addLine(to: CGPoint(x: fillPath.currentPoint.x, y: frame.height))
        fillPath.addLine(to: CGPoint(x: 0, y: frame.height))
        fillPath.close()
        return fillPath
    }

    private func xDivision(open: Date?, close: Date?) -> CGFloat {
        guard let open = open, let close = close else {
            return 0
        }
        return frame.width / (CGFloat(close.timeIntervalSince(open) / 60))
    }

    private func yDivision(highestPrice: CGFloat, lowestPrice: CGFloat) -> CGFloat {
        return frame.height / (highestPrice - lowestPrice)
    }

}


extension String {
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let time = dateFormatter.date(from: self) else { fatalError() }
        return time
    }
}
