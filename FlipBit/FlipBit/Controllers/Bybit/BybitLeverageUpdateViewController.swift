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
    
    private lazy var leverageValueLabel: UILabel = {
        let leverageLabel = UILabel(font: UIFont.title1.bold, textColor: UIColor.Bybit.titleGray)
        leverageLabel.textAlignment = .center
        return leverageLabel
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        return slider
    }()
    
    init(leverage: String) {
        super.init(nibName: nil, bundle: nil)
        slider.value = (leverage as NSString).floatValue
        updateLeverageValue(value: leverage)
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
        view.addSubview(leverageValueLabel)
        view.addSubview(slider)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            leverageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            leverageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leverageValueLabel.topAnchor.constraint(equalTo: leverageTitleLabel.bottomAnchor, constant: Dimensions.Space.margin16),
            leverageValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            slider.topAnchor.constraint(equalTo: leverageValueLabel.bottomAnchor, constant: Dimensions.Space.margin16),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin16)
        ])
    }
    
    func updateLeverageValue(value: String) {
        if value == "0" { leverageValueLabel.text = Constant.cross }
        else { leverageValueLabel.text = value + "x" }
    }
    
    @objc func sliderAction(sender: UISlider) {
        let currentValue = Int(sender.value)
        updateLeverageValue(value: String(currentValue))
    }
    
    @objc func dismissLeverageView(notification: NSNotification) {
        dismiss(animated: true)
    }
}
