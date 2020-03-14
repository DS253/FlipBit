//
//  OrderOptionsCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 2/2/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class OrderOptionsCell: BaseTableViewCell {
    
    private lazy var titleLabel: UILabel = { UILabel(font: UIFont.footnote.bold, textColor: themeManager.themeFontColor, textAlignment: .center) }()
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        backgroundColor = themeManager.themeBackgroundColor
        selectionStyle = .none
        clipsToBounds = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension OrderOptionsCell {
    
    /// Sets the cell text label.
    func configure(title: String) {
        titleLabel.text = title
    }
}
