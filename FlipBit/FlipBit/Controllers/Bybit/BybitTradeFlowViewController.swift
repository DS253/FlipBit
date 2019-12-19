//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: ViewController {
    
    private let indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(indicator)

    //    view.addSubview(dismissButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func dismissView() {
        dismiss(animated: true)
    }
}

extension BybitTradeFlowViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BybitTradeFlowPresentationController(activityIndicator: indicator, presentedViewController: presented, presenting: presenting)
    }
}
