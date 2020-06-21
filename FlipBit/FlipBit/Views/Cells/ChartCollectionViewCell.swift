//  Copyright © 2020 DS Studios. All rights reserved.

import UIKit

/// The CollectionViewCell displays the `ChartView` and `TimeBarView`.
class ChartCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var priceHeader: PriceHeaderView = {
        PriceHeaderView()
    }()
    
    private lazy var hourChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1H"))
    private lazy var dayChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1D"))
    private lazy var weekChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1W"))
    private lazy var monthChartView = ChartView(data: ChartData(fileName: "BYBIT_BTCUSD, 1M"))
    
    private lazy var timeBar: TimeBarView = {
        let view = TimeBarView()
        view.timeDelegate = self
        return view
    }()
    
    private lazy var bottomSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
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
        
        hourChartView.configure(delegate: priceHeader)
        dayChartView.configure(delegate: priceHeader)
        weekChartView.configure(delegate: priceHeader)
        monthChartView.configure(delegate: priceHeader)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        hourChartView.isHidden = false
        dayChartView.isHidden = true
        weekChartView.isHidden = true
        monthChartView.isHidden = true
        
        contentView.addSubview(priceHeader)
        contentView.addSubview(hourChartView)
        contentView.addSubview(dayChartView)
        contentView.addSubview(weekChartView)
        contentView.addSubview(monthChartView)
        contentView.addSubview(timeBar)
        contentView.addSubview(bottomSeparator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        priceHeader.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        hourChartView.snp.makeConstraints { make in
            make.top.equalTo(priceHeader.snp.bottom).offset(Space.margin16)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        dayChartView.snp.makeConstraints { make in
            make.top.equalTo(priceHeader.snp.bottom).offset(Space.margin16)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        weekChartView.snp.makeConstraints { make in
            make.top.equalTo(priceHeader.snp.bottom).offset(Space.margin16)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        monthChartView.snp.makeConstraints { make in
            make.top.equalTo(priceHeader.snp.bottom).offset(Space.margin16)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        timeBar.snp.makeConstraints { make in
            make.top.equalTo(weekChartView.snp.bottom).offset(Space.margin16)
            make.leading.trailing.equalTo(weekChartView)
            make.height.equalTo(Space.margin32)
            make.bottom.equalToSuperview().inset(Space.margin16)
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {}
    
    func configure(delegate: ChartViewDelegate) {
        hourChartView.delegate = delegate
        dayChartView.delegate = delegate
        weekChartView.delegate = delegate
        monthChartView.delegate = delegate
    }
}

extension ChartCollectionViewCell: TimeUpdateDelegate {
    
    /// Display the selected `ChartView`.
    func updateChartTime(time: ChartTime) {
        
        hourChartView.isHidden = true
        dayChartView.isHidden = true
        weekChartView.isHidden = true
        monthChartView.isHidden = true
        
        switch time.rawValue {
        case "1H":
            hourChartView.isHidden = false
            
        case "1D":
            dayChartView.isHidden = false
            
        case "1W":
            weekChartView.isHidden = false
            
        case "1M", "1Y", "All":
            monthChartView.isHidden = false
            
        default:
            break
        }
    }
}
