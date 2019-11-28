//
//  BybitBuyTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitBuyTableViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .buyBookObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(observerUpdatedBuyBook(notification:)), name: .buyBookObserverUpdate, object: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.backgroundColor = UIColor.Bybit.themeBlack
        tableView.backgroundColor = UIColor.Bybit.themeBlack
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(BybitBookOrderBuyCell.self, forCellReuseIdentifier: BybitBookOrderBuyCell.id)
        tableView.isScrollEnabled = false
    }
    
    @objc func observerUpdatedBuyBook(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - init Methods
    override init(configuration: Configuration = .none) {
        super.init(configuration: configuration)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BybitBookOrderBuyCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BybitBookOrderBuyCell.id, for: indexPath) as? BybitBookOrderBuyCell,
            let order = bookObserver.buyBook?[indexPath.row]
            else { return BybitBookOrderBuyCell() }
        
        cell.configure(with: order, multiplier: bookObserver.returnPercentageOfBuyOrder(size: order.size ?? 0))

        return cell
    }
}
