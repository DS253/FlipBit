//
//  TitleTextView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/22/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class TitleTextView: View {

    let titleLabel: UILabel = UILabel(font: UIFont.footnote, textColor: UIColor.flatGray)

    let textField: UITextField = {
        let field = FlipBitTextField(textColor: .black, font: .body)
        field.borderStyle = .none
        field.backgroundColor = .white
        field.layer.borderColor = UIColor.clear.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 7.0
        return field
    }()
    
    // MARK: - Override Methods
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: titleLabel.intrinsicContentSize.width + textField.intrinsicContentSize.width,
                      height: titleLabel.intrinsicContentSize.height + textField.intrinsicContentSize.height)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let viewSpacing: CGFloat = 4.0

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -viewSpacing)
        ])
    }
}
