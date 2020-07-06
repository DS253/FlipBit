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
        UILabel(text: " ", font: .title2, textColor: .white)
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
        contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Space.margin16)
            make.bottom.equalToSuperview().inset(Space.margin8)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
