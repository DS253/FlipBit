//
//  InfoCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 4/12/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: ContainerCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        UILabel(text: " ", font: UIFont.title3, textColor: .white)
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
        add([titleLabel, infoLabel])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(Space.margin8)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
    }
    
    func set(title: String, text: String) {
        titleLabel.text = title
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        configureView()
    }
    
    func configureView() {}


}
