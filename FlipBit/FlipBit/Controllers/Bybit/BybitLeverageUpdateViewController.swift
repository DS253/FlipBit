//
//  BybitLeverageUpdateViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/5/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class BybitLeverageUpdateViewController: ViewController {
    
    private lazy var leverageTitleLabel: UILabel = {
        let leverageLabel = UILabel(font: UIFont.title1.bold, textColor: UIColor.Bybit.titleGray)
        leverageLabel.textAlignment = .center
        leverageLabel.text = Constant.leverage
        return leverageLabel
    }()
    
    init(leverage: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dismissFlow, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.setFrameLengthByPercentage(width: 0.85, height: 0.6)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissLeverageView(notification:)), name: .dismissFlow, object: nil)
        
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.Bybit.white.cgColor
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(leverageTitleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            leverageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            leverageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func dismissLeverageView(notification: NSNotification) {
        dismiss(animated: true)
    }
}
