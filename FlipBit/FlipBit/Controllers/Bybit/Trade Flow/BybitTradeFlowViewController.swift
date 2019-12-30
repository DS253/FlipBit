//
//  BybitTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BybitTradeFlowViewController: ViewController {
    
    private let order: Order
    
    private lazy var pageController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        pageVC.view.backgroundColor = .clear
        return pageVC
    }()
    
    private lazy var colorTheme: UIColor = {
        return (order.side == .Buy) ? UIColor.flatMint : UIColor.flatWatermelon
    }()
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.setFrameLengthByPercentage(width: 0.85, height: 0.85)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        view.layer.cornerRadius = 14
        view.layer.borderColor = colorTheme.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        self.addChild(self.pageController)
        self.pageController.didMove(toParent: self)
        
        self.pageController.setViewControllers([TradeFlowTypeViewController(order: order)], direction: .forward, animated: true, completion: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(pageController.view)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension BybitTradeFlowViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is TradeFlowPriceViewController {
            return TradeFlowTypeViewController(order: order)
        } else if viewController is TradeFlowQuantityViewController {
            return TradeFlowPriceViewController(order: order)
        } else if viewController is TradeFlowStopLossViewController {
            return TradeFlowQuantityViewController(order: order)
        } else if viewController is TradeFlowTakeProfitViewController {
            return TradeFlowStopLossViewController(order: order)
        } else { return nil }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is TradeFlowTypeViewController {
            return TradeFlowPriceViewController(order: order)
        } else if viewController is TradeFlowPriceViewController {
            return TradeFlowQuantityViewController(order: order)
        } else if viewController is TradeFlowQuantityViewController {
            return TradeFlowStopLossViewController(order: order)
        } else if viewController is TradeFlowStopLossViewController {
            return TradeFlowTakeProfitViewController(order: order)
        } else { return nil }
    }
}
