//
//  NetQuilt+Response+Codable.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

extension NetQuilt.Response: Codable {
    private enum CodingKeys: String, CodingKey {
        case allHeaderFields
        case expectedContentLength
        case data
        case mimeType
        case statusCode
        case suggestedFilename
        case textEncodingName
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.allHeaderFields = try container.decodeIfPresent(forKey: .allHeaderFields)
        self.expectedContentLength = try container.decodeIfPresent(Int64.self, forKey: .expectedContentLength)
        self.data = try container.decodeIfPresent(Data.self, forKey: .data)
        self.mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType)
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        self.suggestedFilename = try container.decodeIfPresent(String.self, forKey: .suggestedFilename)
        self.textEncodingName = try container.decodeIfPresent(String.self, forKey: .textEncodingName)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(allHeaderFields, forKey: .allHeaderFields)
        try container.encodeIfPresent(expectedContentLength, forKey: .expectedContentLength)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(mimeType, forKey: .mimeType)
        try container.encodeIfPresent(statusCode, forKey: .statusCode)
        try container.encodeIfPresent(suggestedFilename, forKey: .suggestedFilename)
        try container.encodeIfPresent(textEncodingName, forKey: .textEncodingName)
        try container.encodeIfPresent(url, forKey: .url)
    }
}
