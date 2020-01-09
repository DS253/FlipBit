//
//  BybitTradeFlowPresentationController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowPresentationController: UIPresentationController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect { return UIScreen.main.bounds }
    
    // MARK: - Override Methods
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        backgroundView.frame = UIScreen.main.bounds
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        containerView?.insertSubview(backgroundView, at: 0)
    }
    
    override func presentationTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.3
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.0
        })
    }
    
    @objc func dismissView() {
        NotificationCenter.default.post(name: .dismissFlow, object: nil)
    }
}
