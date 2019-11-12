//
//  NetQuiltError+Codable.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

extension NetQuiltError: Codable {
    private enum CodingKeys: String, CodingKey {
        case decoder
        case data
        case requestable
        case response
        case session
        case unexpected
        case unknown
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Container should only contain a single value for an enum type.
        if container.contains(.decoder) {
            self = .decoder(try container.decode(forKey: .decoder))
        }
        
        // If container contains `stringValue` for `.data` case, initialized as `.data`.
        else if container.contains(.data) {
            self = .data(try container.decode(forKey: .data))
        }
        
        // If container contains `stringValue` for `.requestable` case, initialized as `.requestable`.
        else if container.contains(.requestable) {
            self = .requestable(try container.decode(RequestableError.self, forKey: .requestable))
        }
        
        // If container contains `stringValue` for `.response` case, initialized as `.response`.
        else if container.contains(.response) {
            self = .response(try container.decode(NetQuilt.Response.self, forKey: .response))
        }
        
        // If container contains `stringValue` for `.session` case, initialized as `.session`.
        else if container.contains(.session) {
            self = .session(try container.decode(forKey: .session))
        }
        
        // If container contains `stringValue` for `.unexpected` case, initialized as `.unexpected`.
        else if container.contains(.unexpected) {
            self = .unexpected
        }
        
        // The default value is `.unknown`.
        else {
            self = .unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .decoder(let error):
            try container.encode(error, forKey: .decoder)
        case .data(let error):
            try container.encode(error, forKey: .data)
        case .requestable(let error):
            try container.encode(error, forKey: .requestable)
        case .response(let response):
            try container.encodeIfPresent(response, forKey: .response)
        case .session(let error):
            try container.encode(error, forKey: .session)
        case .unexpected:
            try container.encode(stringValue, forKey: .unexpected)
        case .unknown:
            try container.encode(stringValue, forKey: .unknown)
        }
    }
}
