//
//  MoviesQueryListItemViewModel.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

class MoviesQueryListItemViewModel {
    let query: String
    
    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryListItemViewModel: Equatable {
    static func == (
        lhs: MoviesQueryListItemViewModel,
        rhs: MoviesQueryListItemViewModel
    ) -> Bool {
        return lhs.query == rhs.query
    }
}
