//
//  FadeAnimationTransition.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class FadeAnimationTransition: NSObject {
    
    // MARK: Properties
    
    /// Indicates transition duration. Defaults to 0.4.
    private let duration: TimeInterval
    
    /// Indicates if the view controller is being presented or dismissed.
    private var isPresenting: Bool = false
    
    init(isPresenting: Bool = true, duration: TimeInterval = 0.2) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
}

// MARK: UIViewControllerAnimatedTransitioning

extension FadeAnimationTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: isPresenting ? .to : .from) else { return }
        
        let containerView = transitionContext.containerView
        let startingAlpha: CGFloat = isPresenting ? 0.0 : 1.0
        let finalAlpha: CGFloat = isPresenting ? 1.0 : 0.0
        
        if isPresenting {
            view.alpha = startingAlpha
            containerView.addSubview(view)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: { view.alpha = finalAlpha },
            completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}
