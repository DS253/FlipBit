//
//  BybitBookOrderSellCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitBookOrderSellCell: UITableViewCell {
    
    var bookOrder: Bybit.BookOrder?
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote.bold
        label.textColor = UIColor.Bybit.orderbookRed
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let quantityColorView: View = {
        let view = View()
        view.backgroundColor = UIColor.Bybit.orderbookRed.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var colorWidthConstraint: NSLayoutConstraint = {
        let constraint = quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0)
        return constraint
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
        selectionStyle = .none
        clipsToBounds = true
    }
    
    func setupSubviews() {
        addSubview(quantityColorView)
        addSubview(priceLabel)
        addSubview(quantityLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            quantityColorView.topAnchor.constraint(equalTo: topAnchor),
            quantityColorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            quantityColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -Dimensions.Space.margin8),
            colorWidthConstraint,
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
        ])
    }
}

extension BybitBookOrderSellCell {
    
    func configure(with order: Bybit.BookOrder, multiplier: Double) {
        self.bookOrder = order
        if let orderPrice = order.price {
            priceLabel.text = orderPrice
        }
        if let orderQty = order.size {
            quantityLabel.text = String(orderQty)
        }
        updateQuantityColor(multiplier: multiplier)
    }
    
    func updateQuantityColor(multiplier: Double) {
        colorWidthConstraint.isActive = false
        
        colorWidthConstraint = quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(multiplier))
        colorWidthConstraint.isActive = true
        layoutSubviews()
    }
}
