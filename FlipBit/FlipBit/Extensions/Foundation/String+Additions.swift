//
//  String+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/14/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
    
    func isBackSpace() -> Bool {
        let char = cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        return (isBackSpace == -92)
    }
    
    var isOnlyNumbersAndDecimal: Bool {
        guard let nonNumbers = rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.").inverted) else { return true }
        return nonNumbers.isEmpty
    }
    
    func buildSignature(secretKey: String) -> String {
        return self.hmac(key: secretKey)
    }
    
    private func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
