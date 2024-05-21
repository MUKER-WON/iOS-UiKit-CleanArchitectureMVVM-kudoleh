//
//  DispatchQueueType.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

// MARK: - Extention

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(
            group: nil,
            execute: work
        )
    }
}

// MARK: - Enum



// MARK: - Protocol

protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}


