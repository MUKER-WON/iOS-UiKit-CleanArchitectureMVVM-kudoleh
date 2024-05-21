//
//  DataTransferService.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

final class DefaultDataTransferService: DataTransferService {
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(
        networkService: NetworkService,
        errorResolver: DataTransferErrorResolver =
        DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger =
        DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
    
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E,
        queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response {
        networkService.request(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(
                    data: data,
                    decoder: endPoint.responseDecoder
                )
                queue.asyncExecute {
                    completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(error: error)
                queue.asyncExecute {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response {
        return request(
            endPoint: endPoint,
            queue: DispatchQueue.main,
            completion: completion
        )
    }
    
    func request<E: ResponseRequestable>(
        endPoint: E,
        queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void {
        networkService.request(endPoint: endPoint) { result in
            switch result {
            case .success:
                queue.asyncExecute {
                    completion(.success(()))
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(error: error)
                queue.asyncExecute {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request<E: ResponseRequestable>(
        endPoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void {
        request(
            endPoint: endPoint,
            queue: DispatchQueue.main,
            completion: completion
        )
    }
    
    // MARK: - private func
    
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data: data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(
        error: NetworkError
    ) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - [Response Decoders]

final class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    
    init() { }
    
    func decode<T: Decodable>(
        data: Data
    ) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

final class RawDataResponseDecoder: ResponseDecoder {
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    init() { }
    
    func decode<T: Decodable>(
        data: Data
    ) throws -> T {
        if T.self is Data.Type,
           let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "예상 데이터 유형"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

// MARK: - [Error Resolver]

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    
    func resolve(error: NetworkError) -> any Error {
        return error
    }
}

// MARK: - [Logger]

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: Error) {
        #if DEBUG
        print("--------------")
        print("\(error)")
        #endif
    }
}

// MARK: - Extension

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}

// MARK: - Enum

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

// MARK: - Protocol

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E,
        queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response
    
    @discardableResult
    func request<E: ResponseRequestable>(
        endPoint: E,
        queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
    
    @discardableResult
    func request<E: ResponseRequestable>(
        endPoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
}

protocol ResponseDecoder {
    func decode<T: Decodable>(data: Data) throws -> T
}

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}


