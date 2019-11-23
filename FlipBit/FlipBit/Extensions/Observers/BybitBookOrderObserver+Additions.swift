//
//  BybitBookOrderObserver+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension BybitBookOrderObserver {
    func sortBookOrders(_ bookOrders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        switch side {
        case .Buy:
            buyBook = bookOrders?.sorted {
                if let first = $0?.price, let second = $1?.price {
                    return first > second
                }
                return false
            }
        case .Sell:
            sellBook = bookOrders?.sorted {
                if let first = $0?.price, let second = $1?.price {
                    return first < second
                }
                return false
            }
        }
    }
    
    func updateBookOrders(_ updatedOrders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = updatedOrders else { return }
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = buyBook?.firstIndex(where: { $0?.id == order?.id }) {
                    buyBook?[index] = order
                }
            }
        case .Sell:
            for order in markedOrders {
                if let index = sellBook?.firstIndex(where: { $0?.id == order?.id }) {
                    sellBook?[index] = order
                }
            }
        }
    }
    
    func deleteBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = buyBook?.firstIndex(where: { $0?.id == order?.id }) {
                    buyBook?.remove(at: index)
                }
            }
        case .Sell:
            for order in markedOrders {
                if let index = sellBook?.firstIndex(where: { $0?.id == order?.id}) {
                    sellBook?.remove(at: index)
                }
            }
        }
    }
    
    func insertBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        switch side {
        case .Buy:
            buyBook?.append(contentsOf: markedOrders)
            sortBookOrders(buyBook, side: Bybit.Side.Buy)
        case .Sell:
            sellBook?.append(contentsOf: markedOrders)
            sortBookOrders(sellBook, side: Bybit.Side.Sell)
        }
    }
}
