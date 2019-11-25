//
//  BybitBookOrderObserver+Deserializer.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/23/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension BybitBookOrderObserver {
    
    func determineBookOrderResponseType(_ data: Data?) -> Bybit.BookOrderResponseResult {
        guard
            let response = data,
            let dictionary = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any>
            else {
                return .UnknownResponse
        }
        
        if dictionary["type"] as? String == Bybit.FormatType.Snapshot.rawValue {
            return .Snapshot
        }
        
        if dictionary["type"] as? String == Bybit.FormatType.Update.rawValue {
            guard
                let bookUpdate = try? Bybit.BookUpdate(from: response),
                let update = bookUpdate.update,
                let delete = bookUpdate.delete,
                let insert = bookUpdate.insert
                else { return .DecodingFailure }
            if !update.isEmpty { return .Update }
            else if !delete.isEmpty { return .Delete }
            else if !insert.isEmpty { return .Insert }
            else { return .UnknownResponse }
        }
        
        
        if dictionary.keys.contains("success") {
            return .SocketResponse
        }
        
        return .UnknownResponse
    }
}
