//
//  ChartCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 5/23/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class ChartCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var hourChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1H"))
    private lazy var dayChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1D"))
    private lazy var weekChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1W"))
    private lazy var monthChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1M"))
    
    private lazy var timeBar: TimeBarView = {
        let view = TimeBarView()
        view.timeDelegate = self
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
        hourChartView.isHidden = false
        dayChartView.isHidden = true
        weekChartView.isHidden = true
        monthChartView.isHidden = true
        
        contentView.addSubview(hourChartView)
        contentView.addSubview(dayChartView)
        contentView.addSubview(weekChartView)
        contentView.addSubview(monthChartView)
        contentView.addSubview(timeBar)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        hourChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin20)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        dayChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin20)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        weekChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin20)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        monthChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Space.margin20)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        timeBar.snp.makeConstraints { make in
            make.top.equalTo(weekChartView.snp.bottom)
            make.leading.trailing.equalTo(weekChartView)
            make.bottom.equalToSuperview().inset(Space.margin20)
        }
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {}
}

extension ChartCollectionViewCell: TimeUpdateDelegate {
    func updateChartTime(time: String) {
        switch time {
        case "1H":
            hourChartView.isHidden = false
            dayChartView.isHidden = true
            weekChartView.isHidden = true
            monthChartView.isHidden = true
            
        case "1D":
            hourChartView.isHidden = true
            dayChartView.isHidden = false
            weekChartView.isHidden = true
            monthChartView.isHidden = true
            
        case "1W", "1M", "1Y", "All":
            hourChartView.isHidden = true
            dayChartView.isHidden = true
            weekChartView.isHidden = false
            monthChartView.isHidden = true
            
        default:
            break
        }
    }
}
