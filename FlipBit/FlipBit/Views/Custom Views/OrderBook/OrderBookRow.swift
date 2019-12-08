//
//  OrderBookRow.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookRow: View {
    
    var bookOrder: Bybit.BookOrder?
    var colorTheme: UIColor
    var font: UIFont
    
    private var isAnimating: Bool = false
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = colorTheme
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = UIColor.Bybit.themeBlack
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var quantityColorView: View = {
        let view = View()
        view.backgroundColor = colorTheme.withAlphaComponent(0.3)
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var colorWidthConstraint: NSLayoutConstraint = {
        let constraint = quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0)
        return constraint
    }()
    
    init(font: UIFont, colorTheme: UIColor) {
        self.colorTheme = colorTheme
        self.font = font
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Bybit.white
        clipsToBounds = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(quantityColorView)
        addSubview(priceLabel)
        addSubview(quantityLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            quantityColorView.topAnchor.constraint(equalTo: topAnchor),
            quantityColorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            quantityColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorWidthConstraint,
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin2),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin8),
        ])
    }
}

extension OrderBookRow {
    
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
        
        if !isAnimating {
            self.isAnimating = true
            UIView.animate(withDuration: 0.6, animations: {
                self.layoutSubviews()
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
}
