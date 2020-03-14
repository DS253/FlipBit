//
//  BybitBookOrderCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/26/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitBookOrderCell: BaseTableViewCell {
    
    /// Flag tracks if an animation is in progress.
    private var isAnimating: Bool = false
    
    /// Displays the price of the order.
    private lazy var priceLabel: UILabel = {
        UILabel(font: UIFont.footnote.bold, textColor: cellColorTheme())
    }()
    
    /// Displays the quantity  of the order.
    private let quantityLabel: UILabel = {
        UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.white, textAlignment: .center)
    }()
    
    /// The animating view used to display the quantity of an order.
    private lazy var quantityColorView: View = {
        View(backgroundColor: cellColorTheme().withAlphaComponent(0.3))
    }()
    
    /// The width constraint used to measure the distance of animation.
    private lazy var colorWidthConstraint: NSLayoutConstraint = {
        quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0)
    }()
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        backgroundColor = themeManager.themeBackgroundColor
        selectionStyle = .none
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
            quantityColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -Space.margin8),
            colorWidthConstraint,
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin16),
        ])
    }
    
    func cellColorTheme() -> UIColor {
        fatalError("Child class must provide the supported document")
    }
}

extension BybitBookOrderCell {
    
    /// Sets the cell text labels to the order's data.
    func configure(with order: Bybit.BookOrder, multiplier: Double) {
        if let orderPrice = order.price { priceLabel.text = orderPrice }
        if let orderQty = order.size { quantityLabel.text = String(orderQty) }
        updateQuantityColor(multiplier: multiplier)
    }
    
    /// Animates the color view to a width that is a percentage of the cell's width.
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
