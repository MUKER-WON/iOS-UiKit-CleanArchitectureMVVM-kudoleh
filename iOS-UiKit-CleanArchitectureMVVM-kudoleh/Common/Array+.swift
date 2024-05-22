//
//  Array+.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

extension Array where Element == MoviesPage {
    var movies: [Movie] {
        flatMap { $0.movies }
    }
}
