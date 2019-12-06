//
//  BybitBookOrderCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/26/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitBookOrderCell: UITableViewCell {
    
    var bookOrders: Bybit.BookOrder?
    
    private var isAnimating: Bool = false
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote.bold
        label.textColor = cellColorTheme()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.footnote
        label.textColor = UIColor.Bybit.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var quantityColorView: View = {
        let view = View()
        view.backgroundColor = cellColorTheme().withAlphaComponent(0.3)
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
        backgroundColor = UIColor.Bybit.white
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
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin16),
        ])
    }
    
    func cellColorTheme() -> UIColor {
        fatalError("Child class must provide the supported document")
    }
}

extension BybitBookOrderCell {
    
    func configure(with order: Bybit.BookOrder, multiplier: Double) {
        self.bookOrders = order
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
        
        if !isAnimating {
            self.isAnimating = true
            UIView.animate(withDuration: 0.4, animations: {
                self.layoutSubviews()
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
}
