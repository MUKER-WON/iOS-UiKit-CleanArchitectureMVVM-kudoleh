//
//  DefaultMoviesQueriesRepository.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

final class DefaultMoviesQueriesRepository {
    private var moviesQueriesPersistentStorage: MoviesQueriesStorage
    
    init(
        moviesQueriesPersistentStorage: MoviesQueriesStorage
    ) {
        self.moviesQueriesPersistentStorage =
        moviesQueriesPersistentStorage
    }
}

// MARK: - Extention

extension DefaultMoviesQueriesRepository: MoviesQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    ) {
        moviesQueriesPersistentStorage.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, Error>) -> Void
    ) {
        moviesQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
    
    
}


// MARK: - Enum



// MARK: - Protocol


