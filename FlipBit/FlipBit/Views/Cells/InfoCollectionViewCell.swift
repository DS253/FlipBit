//
//  InfoCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 4/12/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var highLabel: InfoLabel = {
        InfoLabel(title: "Day High")
    }()
    
    private lazy var lowLabel: InfoLabel = {
        InfoLabel(title: "Day Low")
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
        contentView.addSubview(highLabel)
        contentView.addSubview(lowLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        highLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Space.margin16)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Space.margin16)
        }
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {
        guard let newInfo = symbolObserver.symbolInfo else { return }
        if let dayHighPrice = newInfo.highPrice24H {
            highLabel.configure(info: dayHighPrice)
        }
        if let dayLowPrice = newInfo.lowPrice24H {
            lowLabel.configure(info: dayLowPrice)
        }
    }
}
