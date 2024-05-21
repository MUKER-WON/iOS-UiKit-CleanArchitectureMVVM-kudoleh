//
//  ConnectionError.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation


// MARK: - Extention

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError,
              error.isInternetConnectionError
        else {
            return false
        }
        return true
    }
}

// MARK: - Enum



// MARK: - Protocol

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}
