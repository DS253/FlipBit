//
//  BybitSymbolDetailViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/18/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class BybitSymbolDetailViewController: FlipBitCollectionViewController {
                
    /// Displays the current set leverage.
    private lazy var currentLeverageLabel: UILabel = {
        let font = UIFont(name: "AvenirNext-Bold", size: 32.0)
        let label = UILabel(text: Constant.leverage, font: font, textColor: themeManager.themeFontColor, textAlignment: .center)
        label.layer.cornerRadius = 14
        return label
    }()
    
    private lazy var tradeView: TradeFlowView = {
        TradeFlowView()
    }()
    
    private lazy var optionsViewGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.flatNavyBlue.withAlphaComponent(0.45).cgColor, UIColor.flatNavyBlue.withAlphaComponent(0.0).cgColor]
        return gradient
    }()
                
    var leverageStatus: BitService.BybitLeverageStatus?
    var positions: BitService.BybitPositionList?
    
    enum Section: Int, CaseIterable {
        case chart
        case infoTitle
        case info
        case orderBookTitle
        case orderBook
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        services.fetchBybitLeverageStatus { result in
            switch result {
            case let .success(result):
                self.leverageStatus = result
                guard let leverage = self.leverageStatus else { return }
                self.currentLeverageLabel.text = "\(leverage.btcLeverage)x"
            case let.failure(error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        optionsViewGradient.frame = CGRect(x: .zero, y: .zero, width: tradeView.bounds.size.width, height: Space.margin4)
    }
        
    override func setup() {
        super.setup()
        view.backgroundColor = themeManager.themeBackgroundColor
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.id)
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.id)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.id)
        collectionView.register(OrderBookCollectionViewCell.self, forCellWithReuseIdentifier: OrderBookCollectionViewCell.id)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        tradeView.configureButtons(self, action: #selector(tradeButtonTapped(sender:)))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionViewSection = Section(rawValue: section) else { return 0 }
        
        switch collectionViewSection {
        case .chart, .infoTitle, .info, .orderBookTitle, .orderBook:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> BaseCollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return BaseCollectionViewCell(frame: .zero) }
        switch section {
        case .chart:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.id, for: indexPath) as? ChartCollectionViewCell
                else { return ChartCollectionViewCell(frame: .zero) }
            
            return cell
            
        case .infoTitle:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
                else {
                    return TitleCollectionViewCell(frame: .zero)
            }
            cell.configure(title: "Stats")
            return cell
            
        case .info:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id, for: indexPath) as? InfoCollectionViewCell
                else {
                    return InfoCollectionViewCell(frame: .zero)
            }
            
            return cell
            
        case .orderBookTitle:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
                else {
                    return TitleCollectionViewCell(frame: .zero)
            }
            cell.configure(title: "Orderbook")
            return cell
            
        case .orderBook:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBookCollectionViewCell.id, for: indexPath) as? OrderBookCollectionViewCell
                else {
                    return OrderBookCollectionViewCell(frame: .zero)
            }
            
            return cell
        }
    }
        
    @objc func tradeButtonTapped(sender: UIButton) {
        hapticFeedback()
        guard
            let buttonTitle = sender.titleLabel?.text
            else { return }
        

        //        let vc = BybitTradeFlowViewController(order: order)
        //        present(vc, animated: true)
    }
}

extension BybitSymbolDetailViewController: PriceSelection {
    func priceSelected(price: String) {
    }
}

extension BybitSymbolDetailViewController: QuantitySelection {
    func quantitySelected(quantity: String) {
    }
}

extension BybitSymbolDetailViewController: LeverageObserver {
    func leverageUpdated(leverage: String) {
        self.currentLeverageLabel.text = "\(leverage)x"
    }
}

extension BybitSymbolDetailViewController: PriceObserver {
    func priceUpdated(price: String) {
    }
}
