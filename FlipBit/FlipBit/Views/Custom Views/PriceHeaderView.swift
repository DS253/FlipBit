//  Copyright © 2020 DS Studios. All rights reserved.

import UIKit

class PriceHeaderView: BaseView {
    
    private lazy var currencySymbolLabel: UILabel = {
        UILabel(font: UIFont.headline, textColor: .flatWhiteDark)
    }()
    
    private lazy var priceLabel: UILabel = {
        UILabel(text: "  ", font: UIFont.title1, textColor: .white)
    }()
    
    private lazy var currencyTypeLabel: UILabel = {
        UILabel(font: UIFont.body, textColor: .flatWhiteDark)
    }()
    
    private lazy var percentageLabel: UILabel = {
        UILabel(font: UIFont.title3, textColor: .white)
    }()
    
    private lazy var percentageSymbolLabel: UILabel = {
        UILabel(font: UIFont.body, textColor: .flatWhiteDark)
    }()
    
    private lazy var topSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    private lazy var bottomSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(topSeparator)
        addSubview(priceLabel)
        addSubview(percentageLabel)
        addSubview(percentageSymbolLabel)
        addSubview(currencySymbolLabel)
        addSubview(currencyTypeLabel)
        addSubview(bottomSeparator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        topSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin16)
            make.leading.equalTo(currencySymbolLabel.snp.trailing).offset(Space.margin2)
        }
        
        currencySymbolLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Space.margin16)
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(Space.margin2)
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
        
        percentageSymbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(percentageLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(Space.margin8)
            make.centerY.equalTo(percentageLabel.snp.centerY)
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
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let lastPrice = newInfo.lastPrice {
            priceLabel.text = lastPrice
            currencySymbolLabel.text = "$"
            currencyTypeLabel.text = "USD"
        }
        if let dayPercentage = newInfo.prevPcnt24H {
            configurePercentageView(text: dayPercentage)
            percentageSymbolLabel.text = "%"
        }
    }
    
    private func configurePercentageView(text: String) {
        if text.contains("-") {
            percentageLabel.textColor = themeManager.sellTextColor
            percentageSymbolLabel.textColor = themeManager.sellTextColor
            percentageLabel.text = String(text.dropFirst())
        } else {
            percentageLabel.text = text
            percentageLabel.textColor = (text == "0.00") ? .flatWhiteDark : themeManager.buyTextColor
            percentageSymbolLabel.textColor = (text == "0.00") ? .flatWhiteDark : themeManager.buyTextColor
        }
    }
}
