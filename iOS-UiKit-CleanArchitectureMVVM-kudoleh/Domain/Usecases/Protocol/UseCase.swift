//
//  UseCase.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
