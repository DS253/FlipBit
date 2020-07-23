//
//  BybitSymbolSelectionViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/18/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class BybitSymbolSelectionViewController: FlipBitCollectionViewController {
    
    var symbols: BybitTickerList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        services.fetchBybitTickers { result in
            switch result {
            case let .success(result):
                self.symbols = result
                self.collectionView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = themeManager.themeBackgroundColor
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.id)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols?.tickers.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> BaseCollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.id, for: indexPath) as? BaseCollectionViewCell
            else { return BaseCollectionViewCell(frame: .zero) }
        return cell
        //        guard let section = Section(rawValue: indexPath.section) else { return BaseCollectionViewCell(frame: .zero) }
        //        switch section {
        //        case .chart:
        //            guard
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.id, for: indexPath) as? ChartCollectionViewCell
        //                else { return ChartCollectionViewCell(frame: .zero) }
        //
        //            return cell
        //
        //        case .infoTitle:
        //            guard
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
        //                else {
        //                    return TitleCollectionViewCell(frame: .zero)
        //            }
        //            cell.configure(title: "Stats")
        //            return cell
        //
        //        case .info:
        //            guard
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id, for: indexPath) as? InfoCollectionViewCell
        //                else {
        //                    return InfoCollectionViewCell(frame: .zero)
        //            }
        //
        //            return cell
        //
        //        case .orderBookTitle:
        //            guard
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
        //                else {
        //                    return TitleCollectionViewCell(frame: .zero)
        //            }
        //            cell.configure(title: "Orderbook")
        //            return cell
        //
        //        case .orderBook:
        //            guard
        //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBookCollectionViewCell.id, for: indexPath) as? OrderBookCollectionViewCell
        //                else {
        //                    return OrderBookCollectionViewCell(frame: .zero)
        //            }
        //
        //            return cell
        //        }
    }
}
