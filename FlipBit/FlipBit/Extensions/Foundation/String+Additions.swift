//
//  String+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/14/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import CommonCrypto
import CryptoKit
import Foundation

extension String {
    
    /// Returns a Bool value if the String is a backspace character.
    func isBackSpace() -> Bool {
        let char = cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        return (isBackSpace == -92)
    }
    /// Returns a Bool value if the String is a numeric character or decimal point.
    var isOnlyNumbersAndDecimal: Bool {
        guard let nonNumbers = rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.").inverted) else { return true }
        return nonNumbers.isEmpty
    }
    
    /// Generates a String encoded specifically for Bybit's security process.
    func buildSignature(secretKey: String) -> String {
        return self.hmac(key: secretKey)
    }
    
    /// Returns an encrypted String.
    private func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Returns a SHA256 encrypted String.
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { return String(format: "%02x", $0) }.joined()
    }
    
    /// Returns a randomly generated String to be used as the nonce for the Apple Sign In process.
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
