//
//  UITableView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UITableView {

    /// Will set UITableView header view size based on passed in view and its subviews.
    ///
    /// NOTE: This assumes that `view` subviews have their constraints properly set on `init`.
    internal func setHeaderView(_ view: UIView) {
        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        tableHeaderView = view
    }

    private static let reloadDataAnimation: CATransition = {
        let transition = CATransition()
        transition.type = .push
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.fillMode = .forwards
        transition.duration = 0.25

        return transition
    }()

    func reloadData(from animationType: CATransitionSubtype) {

        let animation = UITableView.reloadDataAnimation

        animation.subtype = animationType

        self.layer.add(animation, forKey: Constant.tableViewReloadDataAnimationKey)
        self.reloadData()

    }
}

