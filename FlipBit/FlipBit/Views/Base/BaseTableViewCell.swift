//
//  BaseTableViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 2/2/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

/// TableViewCell base class establishes setup methods.
class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setup() {}
    
    func setupSubviews() {}
    
    func setupConstraints() {}
}
