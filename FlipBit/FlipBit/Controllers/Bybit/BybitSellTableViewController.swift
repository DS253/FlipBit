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

class BybitSellTableViewController: BaseTableViewController, SocketObserverDelegate, BybitSellOrderObserver {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
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
    
    func observer(observer: WebSocketDelegate, didWriteToSocket: String) {
        print("Observer has written to the web socket")
    }
    
    func observerFailedToConnect() {
        print("Observer has failed to connect to the web socket")
    }
    
    func observerDidConnect(observer: WebSocketDelegate) {
        print("Observer has connected to the web socket")
        bookObserver.writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
    }
    
    func observerDidReceiveMessage(observer: WebSocketDelegate) {
//        print("Observer has received messages from the web socket")
        tableView.reloadData()
    }
    
    func observerFailedToDecode(observer: WebSocketDelegate) {
        print("Observer failed to decode the response from the web socket")
    }
    
    func observerUpdatedSellBook() {
        tableView.reloadData()
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


