//
//  InfoCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 4/12/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: ContainerCollectionViewCell {
    
    private lazy var highLabel: InfoLabel = {
        InfoLabel(title: "24 Hour High")
    }()
    
    private lazy var lowLabel: InfoLabel = {
        InfoLabel(title: "24 Hour Low")
    }()
    
    private lazy var infoLabel: UILabel = {
        UILabel(text: " ", font: UIFont.subheadline, textColor: .white)
    }()
    
    private lazy var stackView: UIStackView = {
        UIStackView(axis: .horizontal, views: [highLabel, lowLabel])
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
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.top.trailing.equalToSuperview()
//            make.leading.equalToSuperview().inset(Space.margin8)
//        }
//
//        infoLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom)
//            make.leading.trailing.equalTo(titleLabel)
//            make.bottom.equalToSuperview()
//        }
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
