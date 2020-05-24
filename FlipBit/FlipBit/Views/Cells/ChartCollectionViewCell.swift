//
//  ChartCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 5/23/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class ChartCollectionViewCell: BaseCollectionViewCell {
    
    private var chartData = ChartData(fileName: "BYBIT_BTCUSD, 1W")
    private lazy var chartView = ChartView(data: chartData)
    private lazy var timeBar: TimeBarView = {
        let view = TimeBarView()
        view.timeDelegate = chartView
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubview(chartView)
        contentView.addSubview(timeBar)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin20)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        timeBar.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom)
            make.leading.trailing.equalTo(chartView)
            make.bottom.equalToSuperview().inset(Space.margin20)
        }
    }
        
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {}
}
