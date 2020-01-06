//
//  BybitLeverageUpdateViewController+Delegates.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/5/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

extension BybitLeverageUpdateViewController: UIViewControllerTransitioningDelegate {

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
