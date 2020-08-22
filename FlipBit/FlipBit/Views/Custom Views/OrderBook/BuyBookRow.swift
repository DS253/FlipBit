//
//  BuyBookRow.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/8/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class BuyBookRow: View {
    
    var bookOrder: Bybit.BookOrder?
    var font: UIFont
    
    private var isAnimating: Bool = false
    
    lazy var priceLabel: UILabel = {
        UILabel(text: " ", font: font, textColor: themeManager.buyTextColor)
    }()
    
    lazy var quantityLabel: UILabel = {
        UILabel(text: " ", font: font, textColor: themeManager.themeFontColor, textAlignment: .right)
    }()
    
    private lazy var quantityColorView: View = {
        let view = View(backgroundColor: themeManager.buyTextColor.withAlphaComponent(0.3))
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var colorWidthConstraint: NSLayoutConstraint = { quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0) }()
    
    init(font: UIFont) {
        self.font = font
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        backgroundColor = themeManager.themeBackgroundColor
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
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.margin4),
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin4),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension BuyBookRow {
    
    func configure(with order: Bybit.BookOrder, multiplier: Double) {
        self.bookOrder = order
        if let orderPrice = order.price { priceLabel.text = orderPrice }
        if let orderQty = order.size { quantityLabel.text = String(orderQty) }
        updateQuantityColor(multiplier: multiplier)
    }
    
    func updateQuantityColor(multiplier: Double) {
        
        if !isAnimating {
            colorWidthConstraint.isActive = false
            
            colorWidthConstraint = quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(multiplier))
            colorWidthConstraint.isActive = true
            self.isAnimating = true
            UIView.animate(withDuration: 0.4, animations: {
                self.layoutSubviews()
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
}