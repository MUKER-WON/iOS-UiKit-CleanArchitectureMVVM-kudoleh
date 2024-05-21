//
//  MovieQueryUDS.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

struct MovieQueriesListUserDefaults: Codable {
    var list: [MovieQueryUserDefaults]
}

struct MovieQueryUserDefaults: Codable {
    let query: String
}

extension MovieQueryUserDefaults {
    init(movieQuery: MovieQuery) {
        query = movieQuery.query
    }
}

extension MovieQueryUserDefaults {
    func toDomain() -> MovieQuery {
        return .init(query: query)
    }
}
