//
//  Result+Codable.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

extension Result: Codable where Success: Codable, Failure == NetQuiltError {
    private enum CodingKeys: String, CodingKey {
        case failure
        case success
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Container should only contain a single value for an enum type.
        if container.contains(.failure) {
            self = .failure(try container.decode(NetQuiltError.self, forKey: .failure))
        }
        
        // If container contains `stringValue` for `.data`, initialize as `.data`.
        else if container.contains(.success) {
            self = .success(try container.decode(Success.self, forKey: .success))
        }
        
        // Unexpected error occurred.
        else {
            self = .failure(NetQuiltError.unexpected)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .failure(let error):
            try container.encode(error, forKey: .failure)
        case .success(let value):
            try container.encode(value, forKey: .success)
        }
    }
}
