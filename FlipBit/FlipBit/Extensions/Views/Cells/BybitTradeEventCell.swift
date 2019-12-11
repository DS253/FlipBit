//
//  BybitTradeEventCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeEventCell: UITableViewCell {

    var bookOrders: Bybit.BookOrder?
    
    private var isAnimating: Bool = false
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote.bold
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote
        label.textColor = UIColor.Bybit.themeBlack
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
        
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
    
    func setup() {
        backgroundColor = UIColor.Bybit.white
        selectionStyle = .none
        clipsToBounds = true
    }
    
    func setupSubviews() {
        addSubview(priceLabel)
        addSubview(quantityLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
            priceLabel.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor),
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin16),
            quantityLabel.widthAnchor.constraint(equalTo: priceLabel.widthAnchor)
        ])
    }
}

extension BybitTradeEventCell {
    func configure(tradeEvent: Bybit.TradeEvent) {
        guard
            let price = tradeEvent.price,
            let quantity = tradeEvent.size
            else { return }

        if tradeEvent.side == .Buy {
            priceLabel.textColor = UIColor.flatMintDark
        } else {
            priceLabel.textColor = UIColor.flatRedDark
        }
        
        priceLabel.text = String(format: "%.2f", price)
        quantityLabel.text = String(quantity)
    }
}
