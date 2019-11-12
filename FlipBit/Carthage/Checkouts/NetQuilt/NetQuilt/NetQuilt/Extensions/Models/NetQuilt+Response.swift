//
//  NetQuilt+Response.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// The associated data returned in the response from a URL load request
    struct Response {
        public typealias HeaderFields = NSDictionary

        /// All HTTP header fields of the response.
        public let allHeaderFields: HeaderFields?

        /// The expected length of the response's content.
        public let expectedContentLength: Int64?

        /// The data returned by the server.
        public let data: Data?

        /// The MIME type of the response.
        public let mimeType: String?

        /// The response's HTTP status code.
        public let statusCode: Int?

        /// A suggested filename for the response data.
        public let suggestedFilename: String?

        /// The name of the text encoding provided by the response's originating source.
        public let textEncodingName: String?

        /// The URL for the response.
        public let url: URL?
    }
}

internal extension NetQuilt.Response {
    /// Creates a `Response` instance given the provided parameter(s).
    ///
    /// - Parameters:
    ///   - data:     The Data returned by URLSession completion.
    ///   - response: The URLresponse returned by URLSession completion.
    init(_ data: Data? = nil, _ response: URLResponse? = nil) {
        let response = response as? HTTPURLResponse

        self.allHeaderFields = response?.allHeaderFields as HeaderFields?
        self.expectedContentLength = response?.expectedContentLength
        self.data = data
        self.mimeType = response?.mimeType
        self.statusCode = response?.statusCode
        self.suggestedFilename = response?.suggestedFilename
        self.textEncodingName = response?.textEncodingName
        self.url = response?.url
    }
}
