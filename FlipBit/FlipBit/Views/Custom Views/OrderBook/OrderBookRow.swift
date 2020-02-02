//
//  OrderBookRow.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookRow: View {
    
    weak var priceSelector: PriceSelection?
    weak var quantitySelector: QuantitySelection?
    
    var bookOrder: Bybit.BookOrder?
    var colorTheme: UIColor
    var font: UIFont
    
    private var isAnimating: Bool = false
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(text: " ", font: font, textColor: colorTheme)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceTapped)))
        return label
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel(text: " ", font: font, textColor: themeManager.themeFontColor, textAlignment: .right)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quantityTapped)))
        return label
    }()
    
    private lazy var quantityColorView: View = {
        let view = View(backgroundColor: colorTheme.withAlphaComponent(0.3))
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var colorWidthConstraint: NSLayoutConstraint = { quantityColorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0) }()
    
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
            
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Space.margin2),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.margin4),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.margin4),
            quantityLabel.leadingAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension OrderBookRow {
    
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
    
    @objc func priceTapped() {
        guard let price = priceLabel.text else { return }
        priceSelector?.priceSelected(price: price)
        hapticFeedback()
    }
    
    @objc func quantityTapped() {
        guard let quantity = quantityLabel.text else { return }
        quantitySelector?.quantitySelected(quantity: quantity)
        hapticFeedback()
    }
}
