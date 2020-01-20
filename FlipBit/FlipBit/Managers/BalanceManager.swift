//
//  BalanceManager.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/20/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Foundation

class BalanceManager {
    var btcPosition: BitService.BybitPosition?
    var ethPosition: BitService.BybitPosition?
    var eosPosition: BitService.BybitPosition?
    var xrpPosition: BitService.BybitPosition?
    
    func retrieveBalance() {
        services.fetchBybitPosition { result in
            switch result {
            case let .success(result):
                self.assignPositions(positionList: result)
            case let .failure(error):
                print("FAILURE***FETCH POSITION***FAILURE")
                print(error)
            }
            NotificationCenter.default.post(name: .balanceUpdate, object: nil)
        }
    }
    
    func assignPositions(positionList: BitService.BybitPositionList) {
        btcPosition = positionList.positions.filter { $0.symbol == Bybit.Symbol.BTC }.first
        ethPosition = positionList.positions.filter { $0.symbol == Bybit.Symbol.ETH }.first
        eosPosition = positionList.positions.filter { $0.symbol == Bybit.Symbol.EOS }.first
        xrpPosition = positionList.positions.filter { $0.symbol == Bybit.Symbol.XRP }.first
    }
}
