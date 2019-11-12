//
//  BitService+BBServerTime.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

struct BybitServerTime {

    let time: String

    let response: BybitServerTime.Response

    let exitCode: String

    let exitInfo: String?

    enum Response: String, Decodable {
        case OK
        case failure
    }
}

extension BybitServerTime: Model {

    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case response = "ret_msg"
        case time = "time_now"
        case exit = "ext_code"
        case info = "ext_info"
    }

    /// Decodable conformance
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try values.decode(Response.self, forKey: .response)
        self.time = try values.decode(String.self, forKey: .time)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(time, forKey: .time)
    }
}
