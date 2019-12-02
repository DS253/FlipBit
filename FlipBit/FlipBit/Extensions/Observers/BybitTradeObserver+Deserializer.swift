//
//  BybitTradeObserver+Deserializer.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/1/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension BybitTradeObserver {
    
    func determineTradeEventResponseType(_ data: Data?) -> Bybit.SymbolInfoResponseResult {
        guard
            let response = data,
            let dictionary = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any>
            else {
                return .UnknownResponse
        }
        
        if dictionary.keys.contains("topic") { return .Snapshot }
        if dictionary.keys.contains("success") { return .SocketResponse }
        
        return .UnknownResponse
    }
}
