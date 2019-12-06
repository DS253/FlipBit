//
//  BybitBookOrderObserver+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

//func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping ()-> Void) {
//    CATransaction.begin()
//    CATransaction.setCompletionBlock(completion)
//    pushViewController(viewController, animated: animated)
//    CATransaction.commit()
//}

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
    
    func indexForOrder(order: Bybit.BookOrder?, orders: [Bybit.BookOrder?]?) -> Int? {
        guard
            let newOrders = orders,
            let newOrder = order
            else { return nil }
        return newOrders.firstIndex(where: { $0?.id == newOrder.id })
    }
    
    func updateBookOrders(_ updatedOrders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = updatedOrders else { return }
        var hasOrder = false
        
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = indexForOrder(order: order, orders: buyBook) {
                    buyBook?[index] = order
                    hasOrder = true
                }
            }
            if hasOrder { NotificationCenter.default.post(name: .buyBookObserverUpdate, object: nil) }
        case .Sell:
            for order in markedOrders {
                if let index = indexForOrder(order: order, orders: sellBook) {
                    sellBook?[index] = order
                    hasOrder = true
                }
            }
            if hasOrder { NotificationCenter.default.post(name: .sellBookObserverUpdate, object: nil) }
        }
    }
    
    func deleteBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        var hasOrder = false
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = indexForOrder(order: order, orders: buyBook) {
                    buyBook?.remove(at: index)
                    hasOrder = true
                }
            }
            if hasOrder { NotificationCenter.default.post(name: .buyBookObserverUpdate, object: nil) }
        case .Sell:
            for order in markedOrders {
                if let index = indexForOrder(order: order, orders: sellBook) {
                    sellBook?.remove(at: index)
                    hasOrder = true
                }
            }
            if hasOrder { NotificationCenter.default.post(name: .sellBookObserverUpdate, object: nil) }
        }
    }
    
    func insertBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        switch side {
        case .Buy:
            buyBook?.append(contentsOf: markedOrders)
            sortBookOrders(buyBook, side: Bybit.Side.Buy)
            if !markedOrders.isEmpty { NotificationCenter.default.post(name: .buyBookObserverUpdate, object: nil) }
        case .Sell:
            sellBook?.append(contentsOf: markedOrders)
            sortBookOrders(sellBook, side: Bybit.Side.Sell)
            if !markedOrders.isEmpty { NotificationCenter.default.post(name: .sellBookObserverUpdate, object: nil) }
        }
    }
}

extension BybitBookOrderObserver {
        
    func findLargestOrder(orders: [Bybit.BookOrder?]?) -> Int {
        guard let books = orders?[0..<5] else { return 0 }
        let max = books.max(by: { (a, b) -> Bool in
            guard
                let first = a,
                let second = b,
                let firstSize = first.size,
                let secondSize = second.size
                else { return false }
            return firstSize < secondSize
        })
        guard
            let maxElement = max,
            let size = maxElement?.size
            else { return 0 }
        return size
    }
    
    func returnPercentageOfBuyOrder(size: Int) -> Double {
        let largestOrder = Double(findLargestOrder(orders: buyBook))
        return Double(size) / largestOrder
    }
    
    func returnPercentageOfSellOrder(size: Int) -> Double {
        let largestOrder = Double(findLargestOrder(orders: sellBook))
        return Double(size) / largestOrder
    }
}
