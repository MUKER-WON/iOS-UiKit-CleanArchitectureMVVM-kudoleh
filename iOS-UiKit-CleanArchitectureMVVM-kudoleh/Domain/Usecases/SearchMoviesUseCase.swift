//
//  SearchMoviesUseCase.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let moviesRepository: MoviesRepository
    private let moviesQueriesRepository: MoviesQueriesRepository
    
    init(
        moviesRepository: MoviesRepository,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {
        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {
        return moviesRepository.fetchMoviesList(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached) { [weak self] result in
                guard let self else {
                    completion(.failure(NSError(
                        domain: "SearchMoviesUseCase",
                        code: 0
                    )))
                    return
                }
                if case .success(let moviePage) = result {
                    self.moviesQueriesRepository
                        .saveRecentQuery(
                            query: requestValue.query
                        ) { _ in }
                }
                completion(result)
            }
    }
    
    
}

// MARK: - [SearchMoviesUseCaseRequestValue]

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}

// MARK: - Extention



// MARK: - Enum



// MARK: - Protocol

protocol SearchMoviesUseCase {
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}
