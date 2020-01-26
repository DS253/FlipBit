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
    private var pageIndex: Int = 0
    private lazy var viewControllers: [BaseTradeFlowViewController] = {
        return [TradeFlowTypeViewController(order: order), TradeFlowPriceViewController(order: order), TradeFlowQuantityViewController(order: order), TradeFlowStopLossViewController(order: order), TradeFlowTakeProfitViewController(order: order)]
    }()
    
    private lazy var colorTheme: UIColor = {
        return (order.side == .Buy) ? UIColor.flatMint : UIColor.flatWatermelon
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(title: Constant.next, textColor: colorTheme, font: .body)
        button.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = colorTheme.cgColor
        button.isSelected = true
        return button
    }()
    
    private lazy var pageController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        pageVC.view.backgroundColor = .clear
        return pageVC
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
        view.setFrameLengthByPercentage(width: 0.85, height: 0.6)
        view.setToScreenCenter()
    }
    
    override func setup() {
        super.setup()
        view.layer.cornerRadius = 14
        view.layer.borderColor = colorTheme.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        
        self.addChild(self.pageController)
        self.pageController.didMove(toParent: self)
        
        self.pageController.setViewControllers([TradeFlowTypeViewController(order: order)], direction: .forward, animated: true, completion: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(pageController.view)
        view.addSubview(nextButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin16),
            nextButton.topAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: Space.margin16),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.margin16)
        ])
    }
    
    @objc func nextButtonTapped(sender: Any) {
        if (pageIndex + 1) < viewControllers.count {
            pageIndex += 1
            self.pageController.setViewControllers([viewControllers[pageIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
}
