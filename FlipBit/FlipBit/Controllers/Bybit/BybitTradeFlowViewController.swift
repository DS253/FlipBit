//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: ViewController {
    
    private let backgroundView: View = {
        let view = View()
        view.backgroundColor = .white
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel(font: UIFont.headline, textColor: .blue)
        label.text = "This is a test"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
//        modalTransitionStyle = .crossDissolve
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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setFrameLengthByPercentage(width: 0.7, height: 0.667)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        
        view.backgroundColor = UIColor.Bybit.white
        view.setBybitTheme()
    }

    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(label)

        view.addSubview(dismissButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            label.topAnchor.constraint(equalTo: view.topAnchor),
//            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }

    @objc func dismissView() {
        dismiss(animated: true)
    }
}

extension BybitTradeFlowViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BybitTradeFlowPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationTransition(isPresenting: false)
    }
}
