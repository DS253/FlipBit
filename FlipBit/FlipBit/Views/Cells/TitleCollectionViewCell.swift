//
//  TitleCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/24/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        UILabel(font: UIFont.cambayBold, textColor: .white)
    }()
    
    private lazy var symbolLabel: UILabel = {
        UILabel(text: "BTCUSD", font: UIFont.title3, textColor: .white)
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(symbolLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(Space.margin8)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
    }
    
    func set(for symbol: Bybit.Symbol) {
        titleLabel.text = symbol.rawValue
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {}
}
