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
        var hasOrder = false
        
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = buyBook?.firstIndex(where: { $0?.id == order?.id }) {
                    buyBook?[index] = order
                    hasOrder = true
                }
            }
            if hasOrder { buybookDelegate?.observerUpdatedBuyBook() }
        case .Sell:
            for order in markedOrders {
                if let index = sellBook?.firstIndex(where: { $0?.id == order?.id }) {
                    sellBook?[index] = order
                    hasOrder = true
                }
            }
            if hasOrder { sellbookDelegate?.observerUpdatedSellBook() }
        }
    }
    
    func deleteBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        var hasOrder = false
        switch side {
        case .Buy:
            for order in markedOrders {
                if let index = buyBook?.firstIndex(where: { $0?.id == order?.id }) {
                    buyBook?.remove(at: index)
                    hasOrder = true
                }
            }
            if hasOrder { buybookDelegate?.observerUpdatedBuyBook() }
        case .Sell:
            for order in markedOrders {
                if let index = sellBook?.firstIndex(where: { $0?.id == order?.id}) {
                    sellBook?.remove(at: index)
                    hasOrder = true
                }
            }
            if hasOrder { sellbookDelegate?.observerUpdatedSellBook() }
        }
    }
    
    func insertBookOrders(_ orders: [Bybit.BookOrder?]?, side: Bybit.Side) {
        guard let markedOrders = orders else { return }
        switch side {
        case .Buy:
            buyBook?.append(contentsOf: markedOrders)
            sortBookOrders(buyBook, side: Bybit.Side.Buy)
            if !markedOrders.isEmpty { buybookDelegate?.observerUpdatedBuyBook() }
        case .Sell:
            sellBook?.append(contentsOf: markedOrders)
            sortBookOrders(sellBook, side: Bybit.Side.Sell)
            if !markedOrders.isEmpty { sellbookDelegate?.observerUpdatedSellBook() }
        }
    }
}

extension BybitBookOrderObserver {
    
    func findLargestBuyOrder() -> Int {
        guard let buyBook = buyBook else { return 0 }
        let max = buyBook.max(by: { (a, b) -> Bool in
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
    
    func findLargestSellOrder() -> Int {
        guard let sellBook = sellBook else { return 0 }
        let max = sellBook.max(by: { (a, b) -> Bool in
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
        let largestOrder = Double(findLargestBuyOrder())
        return Double(size) / largestOrder
    }
    
    func returnPercentageOfSellOrder(size: Int) -> Double {
        let largestOrder = Double(findLargestSellOrder())
        return Double(size) / largestOrder
    }
}
