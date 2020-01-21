//
//  BybitTradeFlowViewController+Delegates.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/22/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension BybitTradeFlowViewController: UITextFieldDelegate {
    
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
