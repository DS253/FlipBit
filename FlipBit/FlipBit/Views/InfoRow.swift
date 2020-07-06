//
//  InfoRow.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoRow: BaseView {
    
    private var leftLabel: InfoLabel
    private var rightLabel: InfoLabel
    
    private lazy var leftSeparator: BaseView = {
        BaseView(backgroundColor: UIColor.flatGray.withAlphaComponent(0.5))
    }()
    
    private lazy var rightSeparator: BaseView = {
        BaseView(backgroundColor: UIColor.flatGray.withAlphaComponent(0.5))
    }()
    
    private lazy var container: UIStackView = {
        UIStackView(axis: .horizontal, spacing: Space.margin16)
    }()
    
    init(left: InfoLabel, right: InfoLabel) {
        leftLabel = left
        rightLabel = right
        super.init(backgroundColor: themeManager.darkModeTheme)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        container.addArrangedSubviews([leftLabel, rightLabel])
        addSubview(container)
        addSubview(leftSeparator)
        addSubview(rightSeparator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin8)
            make.leading.trailing.equalToSuperview().inset(Space.margin16)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.width.equalTo(rightLabel.snp.width)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.width.equalTo(leftLabel.snp.width)
        }
        
        leftSeparator.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.leading)
            make.trailing.equalTo(leftLabel.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(Space.margin1)
        }
        
        rightSeparator.snp.makeConstraints { make in
            make.leading.equalTo(rightLabel.snp.leading)
            make.trailing.equalTo(rightLabel.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(Space.margin1)
        }
    }
    
    func update(left: String? = nil, right: String? = nil) {
        if let leftText = left { leftLabel.configure(info: leftText) }
        
        if let rightText = right { rightLabel.configure(info: rightText) }
    }
}
