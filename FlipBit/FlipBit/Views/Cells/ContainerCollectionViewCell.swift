//
//  ContainerCollectionViewCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/22/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class ContainerCollectionViewCell: BaseCollectionViewCell {
    
    private var stackView: UIStackView = {
        UIStackView(axis: .vertical)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, axis: NSLayoutConstraint.Axis = .vertical) {
        stackView = UIStackView(axis: axis)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {}
    
    override func setupSubviews() {
        contentView.addSubview(stackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        ])
    }
    
    func add(_ views: [UIView]) {
        stackView.addArrangedSubviews(views)
    }
}
