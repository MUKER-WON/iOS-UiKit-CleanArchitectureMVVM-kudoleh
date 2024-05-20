//
//  NetworkConfig.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

struct ApiDataNetworkConfig: NetworkConfigurable {
    var baseURL: URL
    var headers: [String : String]
    var queryParameters: [String : String]
    
    init(
        baseURL: URL,
        headers: [String : String] = [:],
        queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }

}

// MARK: - Extention



// MARK: - Enum



// MARK: - Protocol

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
