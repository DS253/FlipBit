//
//  BitService+Service.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

internal extension BitService {
    /// A wrapper around `Atom` library with added ability to map `AtomError` and `Atom.Response` into `BitService`
    /// types without exposing `Atom` (or any other networking library we might use in the future) to the client.
    struct Service {
        /// The `Atom` instance for performing network calls.
        private let session: Atom
        
        /// Creates a `Service` instance given the provided parameter(s).
        internal init() {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
            
            self.session = Atom(serviceConfiguration: Atom.ServiceConfiguration(configuration: .default, decoder: decoder, dispatchQueue: .main))
        }
        
        /// An internal wrapper method around APIs made available by the `Atom` networking library.
        ///
        /// The result returned by `Atom` library will be mapped into `Result<BitService.Response, BitService.Error>` where both the
        /// `Response` and `Error` types are declared and managed by `BitService`. This is to avoid having both `Atom` types leak into the client.
        ///
        /// - Parameters:
        ///   - requestable: The requestable item containing required data for a network call.
        ///   - completion:  The completion containing `Result` where the associated value is either an `BitService.Error` or decoded model instance.
        internal func load(_ requestable: Requestable, _ completion: @escaping (Result<BitService.Response, BitService.Error>) -> Void) {
            session.load(requestable).execute {
                completion($0
                    .flatMap { .success(BitService.Response($0)) }
                    .flatMapError { .failure(BitService.Error($0)) }
                )
            }
        }
        
        /// An internal wrapper method around APIs made available by the `Atom` networking library.
        ///
        /// The result returned by `Atom` library will be mapped into `Result<T: Model, BitService.Error>` where `Error` type is declared and
        /// managed by `BitService`. This is to avoid having `AtomError` type leak into the client.
        ///
        /// - Parameters:
        ///   - requestable: The requestable item containing required data for a network call.
        ///   - type:        The type to decode.
        ///   - completion:  The completion containing `Result` where the associated value is either an `BitService.Error` or decoded model instance.
        internal func load<T: Model>(_ requestable: Requestable, expecting type: T.Type, on completion: @escaping (Result<T, BitService.Error>) -> Void) {
            session.load(requestable).execute(expecting: T.self) {
                completion($0
                    .flatMapError { .failure(BitService.Error($0)) }
                )
            }
        }
    }
}

