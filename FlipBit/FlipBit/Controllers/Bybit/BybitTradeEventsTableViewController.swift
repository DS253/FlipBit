//
//  BybitTradeEventsTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitTradeEventsTableViewController: BaseTableViewController {
    
    // MARK: - init Methods
    
    override init(configuration: Configuration = .none) {
        super.init(configuration: configuration)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tradeEventObserverUpdate, object: nil)
    }
    
    // MARK: - Setup Methods
    
    override func setup() {
        super.setup()
        tableView.register(BybitTradeEventCell.self, forCellReuseIdentifier: BybitTradeEventCell.id)
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventsTable(notification:)), name: .tradeEventObserverUpdate, object: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeManager.themeBackgroundColor
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.backgroundColor = themeManager.themeBackgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        optionsBarIsHidden = true
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeObserver.tradeSnapshot?.trades?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BybitTradeEventCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BybitTradeEventCell.id, for: indexPath) as? BybitTradeEventCell
            else { return BybitTradeEventCell() }
        
        guard
            let trade = tradeObserver.tradeSnapshot?.trades?[indexPath.row]
            else { return cell }
        
        cell.configure(tradeEvent: trade)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc func updateEventsTable(notification: Notification) {
        tableView.reloadData()
    }
}
