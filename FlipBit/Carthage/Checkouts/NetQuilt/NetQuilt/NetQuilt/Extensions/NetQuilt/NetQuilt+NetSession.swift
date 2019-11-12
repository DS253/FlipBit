//
//  NetQuilt+NetSession.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// `NetSession` is a public facing class responsible for managing
    /// `URLSession` configuration, networks calls, and decoding instances of a
    /// data type into internal models.
    ///
    /// `NetSession` is available through the `NetQuilt` instance and cannot be
    /// initialized directly. This is to better separate the responsibilities
    /// of creating a request, network call, and decoding data.
    class NetSession {
        /// The session configuration data.
        private let sessionConfiguration: NetQuilt.NetSessionConfiguration
        /// The `URLSession` instance configured from `NetQuilt.NetSession`.
        private let session: URLSession
        
        /// The requestable item to initialize `URLRequest` with.
        private var requestable: Requestable
        
        /// Creates a `NetSession` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - sessionConfiguration: The session configuration data.
        internal init(sessionConfiguration: NetQuilt.NetSessionConfiguration) {
            self.requestable = NetQuilt.Endpoint()
            self.sessionConfiguration = sessionConfiguration
            self.session = URLSession(configuration: sessionConfiguration.sessionConfiguration)
        }
    }
}

internal extension NetQuilt.NetSession {
    /// See `NetQuilt.cancellAllSessionTasks` for documentation.
    func cancelAllSessionTasks() {
        session.getAllTasks {
            $0.forEach { $0.cancel() }
        }
    }
    
    /// Update requestable instance property with new data.
    func update(with requestable: Requestable) -> NetQuilt.NetSession {
        self.requestable = requestable
        
        return self
    }
}

public extension NetQuilt.NetSession {
    /// Creates and executes `URLRequest` initialized from `Requestable`.
    ///
    /// Use this method to download files. After file is successfully downloaded to a
    /// temporary location predetermined by `URLSession`, NetQuilt will attempt to initialize
    /// an instance of `Data` using temporary `URL` before file is discarded and is no longer available.
    ///
    /// To ensure downloaded file persist through application's lifecycle, clients should consider
    /// persisting it to the file system using the `suggestedFilename`.
    ///
    /// This method returns immediately on a thread `NetQuilt` was created on.
    ///
    /// A typical usage pattern for this method after getting a `result` could look like this:
    /// ````
    /// netQuilt.load(endpoint).download { result in
    ///     switch result {
    ///         case .failure(let error):
    ///         // Handle `NetQuiltError`.
    ///
    ///         case .success(let file):
    ///         // Handle `NetQuilt.File`.
    ///         }
    ///     }
    /// }
    /// ````
    ///
    /// - Parameters:
    ///   - completion: The completion containing `Result` where the associated value is either an `NetQuiltError` or `NetQuilt.File`.
    ///
    /// - Returns: An optional instance of `URLSessionDownloadTask` in a `.running` state.
    @discardableResult
    func download(_ completion: @escaping (Result<NetQuilt.File, NetQuiltError>) -> Void) -> URLSessionDownloadTask? {
        // Get dispatch queue from `NetSessionConfiguration`.
        let queue = sessionConfiguration.dispatchQueue

        // An instance of `URLSessionDataTask` to resume.
        var task: URLSessionDownloadTask?

        do {
            // Initialize `URLRequest` with requestable instance.
            let request = try URLRequest(requestable: requestable)

            // Start a network call.
            task = session.downloadTask(with: request) { tmp, response, error in
                // Process error returned by the service.
                if let error = error?.nsError {
                    queue.async { completion(Result(NetQuiltError.session(error))) }
                }

                // Process error response returned by the service.
                else if response?.isFailure == true {
                    queue.async { completion(Result(NetQuiltError.response(NetQuilt.Response(nil, response)))) }
                }

                // Process temporary file url returned by the service.
                else if let temporaryFileUrl = tmp {
                    do {
                        // Try to create Data instance from temporary file URL.
                        let data = try Data(contentsOf: temporaryFileUrl)

                        // Initialize a file instance using data and suggested filename.
                        let file = NetQuilt.File(data: data, suggestedFilename: response?.suggestedFilename)

                        // Initialize a result instance on the background queue.
                        let result = Result<NetQuilt.File, NetQuiltError>(file)

                        // Call completion on the queue `NetQuilt.NetSession` was configured to use.
                        queue.async { completion(result) }

                    } catch {
                        // Error initializing data from downloaded file.
                        queue.async { completion(Result(NetQuiltError.data(error.nsError))) }
                    }
                }

                // Neither error, response nor temporary file url returned. Notify the client of the `unknown` error.
                else { queue.async { completion(Result(NetQuiltError.unknown)) } }
            }

            // Resume data task.
            task?.resume()

        } catch let error as RequestableError {
            // Error initializing `URLRequest` from requestable instance.
            queue.async { completion(Result(NetQuiltError.requestable(error))) }

        } catch {
            // Unexpected, logical error occured.
            queue.async { completion(Result(NetQuiltError.unexpected)) }
        }

        return task
    }
    
    /// Creates and executes `URLRequest` initialized from `Requestable`.
    ///
    /// Use this method to make network requests where you expect data returned by the
    /// service and require that data to be decoded into internal representations - models.
    ///
    /// This method returns immediately on a thread `NetQuilt` was created on.
    ///
    /// - Note:
    ///   Network request and decoding will be performed on a background thread after
    ///   which the client will be notified of a `result` on a queue `NetQuilt` was configured to use.
    ///
    /// A typical usage pattern for this method could look like this:
    /// ````
    /// netQuilt.load(endpoint).execute(expecting: User.self) { result in
    ///     switch result {
    ///         case .failure(let error):
    ///         // Handle `NetQuiltError`.
    ///
    ///         case .success(let user):
    ///         // Handle decoded `User` instance.
    ///     }
    /// }
    /// ````
    /// In the above example, data will be decoded into a `User` instance.
    ///
    /// - Parameters:
    ///   - type:       The type to decode.
    ///   - completion: The completion containing `Result` where the associated value is either an `NetQuiltError` or decoded model instance.
    ///
    /// - Returns: An optional instance of `URLSessionDataTask` in a `.running` state.
    @discardableResult
    func execute<T: Model>(expecting type: T.Type, completion: @escaping (Result<T, NetQuiltError>) -> Void) -> URLSessionDataTask? {
        // Get decoder from `NetSessionConfiguration`.
        let decoder = sessionConfiguration.decoder

        // Get dispatch queue from `NetSessionConfiguration`.
        let queue = sessionConfiguration.dispatchQueue

        // An instance of `URLSessionDataTask` to resume.
        var task: URLSessionDataTask?
        
        do {
            // Initialize `URLRequest` with requestable instance.
            let request = try URLRequest(requestable: requestable)

            // Start a network call.
            task = session.dataTask(with: request) { data, response, error in
                // Process error returned by the service.
                if let error = error?.nsError {
                    queue.async { completion(Result(NetQuiltError.session(error))) }
                }

                // Process error response returned by the service.
                else if response?.isFailure == true {
                    queue.async { completion(Result(NetQuiltError.response(NetQuilt.Response(data, response)))) }
                }

                // Process data returned by the service.
                else if let data = data {
                    // Check for expected type. Data conforms to `Model` and is supported return type.
                    if let value = data as? T {
                        // Initialize a result instance on the background queue.
                        let result = Result<T, NetQuiltError>(value)

                        // Call completion on the queue `NetQuilt.NetSession` was configured to use.
                        queue.async { completion(result) }
                    }

                    // Client expects fully decoded instance.
                    else {
                        do {
                            // Decode model object from data on the background queue.
                            let value = try decoder.decode(T.self, from: data)

                            // Initialize a result instance on the background queue.
                            let result = Result<T, NetQuiltError>(value)

                            // Call completion on the queue `NetQuilt.NetSession` was configured to use.
                            queue.async { completion(result) }

                        } catch {
                            // Notify the client of the decoding error returned by `JSONDecoder`.
                            queue.async { completion(Result(NetQuiltError.decoder(error.nsError))) }
                        }
                    }
                }

                // Neither error, response nor data returned. Notify the client of the `unknown` error.
                else { queue.async { completion(Result(NetQuiltError.unknown)) } }
            }

            // Resume data task.
            task?.resume()

        } catch let error as RequestableError {
            // Error initializing `URLRequest` from requestable instance.
            queue.async { completion(Result(NetQuiltError.requestable(error))) }

        } catch {
            // Unexpected, logical error occured.
            queue.async { completion(Result(NetQuiltError.unexpected)) }
        }

        return task
    }
    
    /// Creates and executes `URLRequest` initialized from `Requestable`.
    ///
    /// Use this method to make network requests where you don't expect any data returned
    /// and are only interested in knowing if the network call succeeded or failed.
    ///
    /// This method returns immediately on a thread `NetQuilt` was created on.
    ///
    /// `NetQuilt` framework uses a convenience computed variable on `URLResponse` - `isSuccessful`
    /// to determine success or a failure of a response based on a status code returned by the service.
    ///
    /// A typical usage pattern for this method after getting a `result` could look like this:
    /// ````
    /// netQuilt.load(endpoint).execute { result in
    ///     switch result {
    ///         case .failure(let error):
    ///         // Handle `NetQuiltError`.
    ///
    ///         case .success(let response):
    ///         // Handle `URLResponse`.
    ///         }
    ///     }
    /// }
    /// ````
    ///
    /// - Parameters:
    ///   - completion: The completion containing `Result` where the associated value is either an `NetQuiltError` or `URLResponse`.
    ///
    /// - Returns: An optional instance of `URLSessionDataTask` in a `.running` state.
    @discardableResult
    func execute(_ completion: @escaping (Result<NetQuilt.Response, NetQuiltError>) -> Void) -> URLSessionDataTask? {
        // Get dispatch queue from `NetSessionConfiguration`.
        let queue = sessionConfiguration.dispatchQueue

        // An instance of `URLSessionDataTask` to resume.
        var task: URLSessionDataTask?
        
        do {
            // Initialize `URLRequest` with requestable instance.
            let request = try URLRequest(requestable: requestable)

            // Start a network call.
            task = session.dataTask(with: request) { data, response, error in
                // Process error returned by the service.
                if let error = error?.nsError {
                    queue.async { completion(Result(NetQuiltError.session(error))) }
                }

                // Process response returned by the service.
                else if response?.isSuccessful == true {
                    // Initialize `success` case with response object.
                    queue.async { completion(Result(NetQuilt.Response(data, response))) }
                }

                // Service returned invalid response (based on `statusCode`). Initialize `failure` case with response and optional `data` object.
                else { queue.async {
                    completion(Result(NetQuiltError.response(NetQuilt.Response(data, response)))) }
                }
            }

            // Resume data task.
            task?.resume()

        } catch let error as RequestableError {
            // Error initializing `URLRequest` from requestable instance.
            queue.async { completion(Result(NetQuiltError.requestable(error))) }

        } catch {
            // Unexpected, logical error occured.
            queue.async { completion(Result(NetQuiltError.unexpected)) }
        }

        return task
    }
}

