//
//  TitleCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/24/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: ContainerCollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        UILabel(text: "", font: UIFont.title1.bold, textColor: .white)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        add([titleLabel])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}
