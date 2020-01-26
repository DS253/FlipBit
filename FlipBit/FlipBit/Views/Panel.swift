//
//  Panel.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/14/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class Panel: View {
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = Space.margin8
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        setBybitTheme()
        backgroundColor = UIColor.Bybit.white
        isUserInteractionEnabled = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin8)
        ])
    }
    
    func addSubviews(views: [UIView]) {
        stackView.addArrangedSubviews(views)
    }
}
