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

        return view
    }()

    private let activityIndicator: UIActivityIndicatorView

    override var frameOfPresentedViewInContainerView: CGRect { return UIScreen.main.bounds }

    // MARK: - Override Methods

    init(activityIndicator: UIActivityIndicatorView, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.activityIndicator = activityIndicator
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        backgroundView.frame = UIScreen.main.bounds
        containerView?.insertSubview(backgroundView, at: 0)
    }

    override func presentationTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.4
            }, completion: { [weak self] _ in
                self?.activityIndicator.startAnimating()
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.activityIndicator.stopAnimating()
            self?.backgroundView.alpha = 0.0
        }, completion: nil)
    }
}

