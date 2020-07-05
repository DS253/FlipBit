//
//  InfoCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 4/12/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var firstRow: InfoRow = {
        let row = InfoRow(left: InfoLabel(title: "Mark Price"),
                          right: InfoLabel(title: "Index Price"))
        return row
    }()
    
    private lazy var firstRowSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    private lazy var secondRow: InfoRow = {
        let row = InfoRow(left: InfoLabel(title: "24h High"),
                          right: InfoLabel(title: "24h Low"))
        return row
    }()
    
    private lazy var secondRowSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    private lazy var thirdRow: InfoRow = {
        let row = InfoRow(left: InfoLabel(title: "24h Turnover"),
                          right: InfoLabel(title: "24h Volume"))
        return row
    }()
    
    private lazy var thirdRowSeparator: BaseView = {
        BaseView(backgroundColor: .flatWhiteDark)
    }()
    
    private lazy var infoLabel: UILabel = {
        UILabel(text: " ", font: UIFont.subheadline, textColor: .white)
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
        contentView.addSubview(firstRow)
        contentView.addSubview(firstRowSeparator)
        contentView.addSubview(secondRow)
        contentView.addSubview(secondRowSeparator)
        contentView.addSubview(thirdRow)
        contentView.addSubview(thirdRowSeparator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        firstRow.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(secondRow.snp.top)
        }
        
        firstRowSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.bottom.equalTo(firstRow.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        secondRow.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(thirdRow.snp.top)
        }
        
        secondRowSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.bottom.equalTo(secondRow.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
        
        thirdRow.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        thirdRowSeparator.snp.makeConstraints { make in
            make.height.equalTo(Space.margin1)
            make.bottom.equalTo(thirdRow.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Space.margin8)
        }
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let markPrice = newInfo.markPrice {
            firstRow.update(left: markPrice.formatPriceString(notation: 4))
        }
        if let indexPrice = newInfo.indexPrice {
            firstRow.update(right: indexPrice.formatPriceString(notation: 4))
        }
        if let dayHighPrice = newInfo.highPrice24H {
            secondRow.update(left: dayHighPrice.formatPriceString(notation: 4))
        }
        if let dayLowPrice = newInfo.lowPrice24H {
            secondRow.update(right: dayLowPrice.formatPriceString(notation: 4))
        }
        if let turnover = newInfo.turnover24H {
            thirdRow.update(left: turnover)
        }
        if let volume = newInfo.volume24H {
            thirdRow.update(right: String(volume))
        }
    }
}
