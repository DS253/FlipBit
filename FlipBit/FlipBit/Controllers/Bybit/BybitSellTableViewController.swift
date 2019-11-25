//
//  BybitSellTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

protocol BybitSellOrderObserver: class {
    func observerUpdatedSellBook()
}

class BybitSellTableViewController: BaseTableViewController, BybitSellOrderObserver {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setup() {
        super.setup()
        bookObserver.sellbookDelegate = self
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(BybitBookOrderSellCell.self, forCellReuseIdentifier: BybitBookOrderSellCell.id)
    }
    
    func observerUpdatedSellBook() {
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
        return bookObserver.sellBook?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BybitBookOrderSellCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BybitBookOrderSellCell.id, for: indexPath) as? BybitBookOrderSellCell,
            let order = bookObserver.sellBook?[indexPath.row]
            else { return BybitBookOrderSellCell() }
        
        cell.configure(with: order, multiplier: bookObserver.returnPercentageOfSellOrder(size: order.size ?? 0))

        return cell
    }
}
