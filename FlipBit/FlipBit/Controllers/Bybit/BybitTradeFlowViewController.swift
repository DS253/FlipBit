//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: ViewController {

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.buy, textColor: UIColor.Bybit.white)
        button.titleLabel?.font = UIFont.title3.bold
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.Bybit.white.cgColor
        button.layer.cornerRadius = 7.0
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    override func setup() {
        super.setup()
        view.backgroundColor = .red
    }

    override func setupSubviews() {
        super.setupSubviews()

        view.addSubview(dismissButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func dismissView() {
        dismiss(animated: true)
    }
}
