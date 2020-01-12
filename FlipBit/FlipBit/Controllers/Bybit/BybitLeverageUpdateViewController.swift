//
//  BybitLeverageUpdateViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/5/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol LeverageObserver: class {
    func leverageUpdated(leverage: String)
}

class BybitLeverageUpdateViewController: ViewController {
    
    private weak var leverageDelegate: LeverageObserver?
    
    private lazy var leverageTitleLabel: UILabel = {
        let leverageLabel = UILabel(font: UIFont.title1.bold, textColor: UIColor.flatMint)
        leverageLabel.textAlignment = .center
        leverageLabel.text = Constant.leverage
        return leverageLabel
    }()
    
    private lazy var leverageValueLabel: UILabel = {
        let leverageLabel = UILabel(font: UIFont.largeTitle.bold, textColor: UIColor.flatMint)
        leverageLabel.textAlignment = .center
        return leverageLabel
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor.flatMint
        slider.maximumTrackTintColor = UIColor.flatMint
        return slider
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.updateLeverage, textColor: UIColor.flatMint)
        button.addTarget(self, action: #selector(updateLeverage(sender:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.body
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = UIColor.flatMintDark.cgColor
        button.isSelected = true
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Dimensions.Space.margin20
        stackView.addArrangedSubviews([leverageTitleLabel, leverageValueLabel, slider, updateButton])
        return stackView
    }()
    
    init(leverage: String, observer: LeverageObserver) {
        super.init(nibName: nil, bundle: nil)
        self.leverageDelegate = observer
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
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissLeverageView(notification:)), name: .dismissFlow, object: nil)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.Bybit.white.cgColor
        view.layer.masksToBounds = false
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimensions.Space.margin16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.Space.margin16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin16),
            
            slider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100)
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
    
    @objc func updateLeverage(sender: Any) {
        services.updateBybitLeverage(symbol: .BTC, leverage: String(Int(slider.value))) { result in
            switch result {
            case .success(_):
                self.leverageDelegate?.leverageUpdated(leverage: String(Int(self.slider.value)))
                self.dismiss(animated: true)
            case let.failure(error):
                print(error)
            }
        }
        vibrate()
    }
    
    @objc func dismissLeverageView(notification: NSNotification) {
        dismiss(animated: true)
    }
}
