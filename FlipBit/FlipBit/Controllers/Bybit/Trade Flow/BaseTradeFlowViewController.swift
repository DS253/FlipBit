//
//  BaseTradeFlowViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BaseTradeFlowViewController: ViewController {
    
    var isVisible: Bool = false
    
    var order: Order
    
    lazy var colorTheme: UIColor = {
        return (order.side == .Buy) ? themeManager.buyTextColor : themeManager.sellTextColor
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
    }
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dismissFlow, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissTradeFlow(notification:)), name: .dismissFlow, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTextField)))
    }
    
    @objc func dismissTradeFlow(notification: NSNotification) {}
    
    @objc func dismissTextField() {}
}
