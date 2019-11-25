//
//  BybitBuyTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitBuyTableViewController: BaseTableViewController, SocketObserverDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.register(BybitBookOrderBuyCell.self, forCellReuseIdentifier: BybitBookOrderBuyCell.id)
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
    
    // MARK: - UITableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookObserver.buyBook?.count ?? 0
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
