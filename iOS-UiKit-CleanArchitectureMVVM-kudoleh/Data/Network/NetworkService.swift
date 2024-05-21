//
//  NetworkService.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

final class DefaultNetworkService: NetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager =
        DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger =
        DefaultNetworkErrorLogger()
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    func request(
        endPoint: Requestable,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {
        do {
            let urlRequest = try endPoint.urlRequest(config: config)
            return request(request: urlRequest, completion: completion)
        }
        catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
    // MARK: - private func
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        let sessionDataTask = sessionManager.request(
            request: request
        ) { data, response, requestError in
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(data: data, response: response)
                completion(.success(data))
            }
        }
        logger.log(request: request)
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: 
            return .notConnected
        case .cancelled: 
            return .cancelled
        default: 
            return .generic(error)
        }
    }
}

// MARK: - [Default Network Session Manager]

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: completion
        )
        task.resume()
        return task
    }
    
    
}

// MARK: - [Logger]

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }
    
    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody,
           let result =
            (
                (
                    try? JSONSerialization.jsonObject(
                        with: httpBody,
                        options: []
                    ) as? [String: AnyObject]
                ) as [String: AnyObject]??
           ) {
            #if DEBUG
            print("body: \(String(describing: result))")
            #endif
        } else if let httpBody = request.httpBody,
                  let resultString = String(
                    data: httpBody, encoding: .utf8
                  ) {
            #if DEBUG
            print("body: \(String(describing: resultString))")
            #endif
        }
    }
    
    func log(
        data: Data?,
        response: URLResponse?
    ) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as? [String: Any] {
            #if DEBUG
            print("responseData: \(String(describing: dataDict))")
            #endif
        }
    }

    func log(error: Error) {
        #if DEBUG
        print("\(error)")
        #endif
    }
}

// MARK: - Extention

extension URLSessionTask: NetworkCancellable {
    
}

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(codeError: 404) }
    
    func hasStatusCode(codeError: Int) -> Bool {
        switch self {
        case let .error(statusCode: code, data: _):
            return code == codeError
        default:
            return false
        }
    }
}

// MARK: - Enum

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

// MARK: - Protocol

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(
        endPoint: Requestable,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable?
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(data: Data?, response: URLResponse?)
    func log(error: Error)
}

protocol NetworkCancellable {
    func cancel()
}
