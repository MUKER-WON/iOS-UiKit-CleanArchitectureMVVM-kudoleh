//
//  EndPoint.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

final class EndPoint<R>: ResponseRequestable {
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String : String]
    let queryParametersEncodable: (any Encodable)?
    let queryParameters: [String : Any]
    let bodyParametersEncodable: (any Encodable)?
    let bodyParameters: [String : Any]
    let bodyEncoder: BodyEncoder
    let responseDecoder: ResponseDecoder
    
    init(
        path: String,
        isFullPath: Bool = false,
        method: HTTPMethodType,
        headerParameters: [String : String] = [:],
        queryParametersEncodable: (any Encodable)? = nil,
        queryParameters: [String : Any] = [:],
        bodyParametersEncodable: (any Encodable)? = nil,
        bodyParameters: [String : Any] = [:],
        bodyEncoder: BodyEncoder = JSONBodyEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

// MARK: - [JsonBodyEncoder]

struct JSONBodyEncoder: BodyEncoder {
    // TODO: JSONSerialization -> Codable
    func encode(parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
    
}

// MARK: - [AsciiBodyEncoder]

struct AsciiBodyEncoder: BodyEncoder {
    func encode(parameters: [String : Any]) -> Data? {
        return parameters.queryString.data(
            using: String.Encoding.ascii,
            allowLossyConversion: true
        )
    }
}

// MARK: - Extention

extension Requestable {
    func url(config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endPoint = isFullPath ? path : baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endPoint)
        else {
            throw RequestGenerationError.components
        }
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = try queryParametersEncodable?.toDictionary()
        ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(
                name: $0.key,
                value: "\($0.value)")
            )
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(
                name: $0.key,
                value: $0.value)
            )
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty
        ? urlQueryItems
        : nil
        guard let url = urlComponents.url
        else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(
        config: NetworkConfigurable
    ) throws -> URLRequest {
        let url = try self.url(config: config)
        var urlRequest = URLRequest(url: url)
        var headers = config.headers
        headerParameters.forEach { headers.updateValue($1, forKey: $0) }
        let bodyParameters = try bodyParametersEncodable?.toDictionary()
        ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(
                parameters: bodyParameters
            )
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

// MARK: - Enum

enum HTTPMethodType: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum RequestGenerationError: Error {
    case components
}

// MARK: - Protocol

/// 베이스가 되는 networkRequest 프로토콜
protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: BodyEncoder { get }
    
    func urlRequest(
        config: NetworkConfigurable
    ) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

protocol BodyEncoder {
    func encode(parameters: [String: Any]) -> Data?
}
