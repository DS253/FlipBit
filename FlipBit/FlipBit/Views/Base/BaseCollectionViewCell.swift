//
//  BaseCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/22/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

/// CollectionViewCell base class establishes setup methods.
class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
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
