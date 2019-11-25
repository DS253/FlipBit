//
//  BybitSellTableViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/24/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitSellTableViewController: BaseTableViewController, SocketObserverDelegate {
    
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
        tableView.register(BybitTradeCell.self, forCellReuseIdentifier: BybitTradeCell.id)
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
        return bookObserver.sellBook?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BybitTradeCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BybitTradeCell.id, for: indexPath) as? BybitTradeCell
            else { return BybitTradeCell() }
        
        guard

            let sellPrice = bookObserver.sellBook?[indexPath.row]?.price,
            let sellSize = bookObserver.sellBook?[indexPath.row]?.size
            
            else { return BybitTradeCell() }
        
        cell.textLabel?.text = "\(sellPrice)" + "    \(sellSize)"
        
        
        return cell
    }
}


