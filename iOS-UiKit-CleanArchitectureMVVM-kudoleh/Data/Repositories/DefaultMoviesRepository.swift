//
//  DefaultMoviesRepository.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

final class DefaultMoviesRepository {
    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        cache: MoviesResponseStorage,
        backgroundQueue: DataTransferDispatchQueue =
        DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

// MARK: - Extention

extension DefaultMoviesRepository: MoviesRepository {
    func fetchMoviesList(
        query: MovieQuery,
        page: Int,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, any Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = MoviesRequestDTO(
            query: query.query,
            page: page
        )
        let task = RepositoryTask()
        cache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }
            let endPoint = APIEndPoints.getMovies(with: requestDTO)
            task.networkTask = self?.dataTransferService.request(
                with: endPoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case .success(let responseDTO):
                    self?.cache.save(
                        response: responseDTO,
                        for: requestDTO
                    )
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    
}



// MARK: - Enum



// MARK: - Protocol


