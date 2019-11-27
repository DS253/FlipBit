//
//  BybitBuyTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

protocol BybitBuyOrderObserver: class {
    func observerUpdatedBuyBook()
}

class BybitBuyTableViewController: BaseTableViewController, BybitBuyOrderObserver {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setup() {
        super.setup()
        bookObserver.buybookDelegate = self
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(BybitBookOrderBuyCell.self, forCellReuseIdentifier: BybitBookOrderBuyCell.id)
    }
    
    func observerUpdatedBuyBook() {
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
