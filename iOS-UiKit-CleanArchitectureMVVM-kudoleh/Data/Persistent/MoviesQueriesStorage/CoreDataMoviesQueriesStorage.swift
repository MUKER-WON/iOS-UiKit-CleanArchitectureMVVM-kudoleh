//
//  CoreDataMoviesQueriesStorage.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation
import CoreData

final class CoreDataMoviesQueriesStorage {
    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage
    
    init(
        maxStorageLimit: Int,
        coreDataStorage: CoreDataStorage = CoreDataStorage.shared
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private func
    
    private func cleanUpQueries(
        for query: MovieQuery,
        inContext context: NSManagedObjectContext
    ) throws {
        let request = MovieQueryEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(
                key: #keyPath(MovieQueryEntity.createdAt),
                ascending: false
            )
        ]
        var result = try context.fetch(request)
        removeDuplicates(
            for: query,
            in: &result,
            inContext: context
        )
        removeQueries(
            limit: maxStorageLimit - 1,
            in: result,
            inContext: context
        )
    }
    
    private func removeDuplicates(
        for query: MovieQuery,
        // inout을 쓴 이유
        // 함수 호출이 끝난 후에도 변경된 값이 호출한 쪽에 반영되도록 하기 위함
        // 즉 함수 내부에서 인자의 값을 직접 수정할 수 있음
        in queries: inout [MovieQueryEntity],
        inContext context: NSManagedObjectContext
    ) {
        // queries에서 query와 동일한 값을 가진 요소를 필터링하여 context에서 삭제
        queries
            .filter { $0.query == query.query }
            .forEach { context.delete($0) }
        // queries에서 query와 동일한 값을 가진 모든 요소를 제거
        queries.removeAll { $0.query == query.query }
    }
    
    private func removeQueries(
        limit: Int,
        in queries: [MovieQueryEntity],
        inContext context: NSManagedObjectContext
    ) {
        guard queries.count > limit else { return }
        queries.suffix(queries.count - limit).forEach {
            context.delete($0)
        }
    }
}

// MARK: - Extention

extension CoreDataMoviesQueriesStorage: MoviesQueriesStorage {
    
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request = MovieQueryEntity.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(
                        key: #keyPath(MovieQueryEntity.createdAt),
                        ascending: false
                    )
                ]
                request.fetchLimit = maxCount
                let result = try context.fetch(request).map {
                    $0.toDomain()
                }
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self else { return }
            do {
                try self.cleanUpQueries(
                    for: query,
                    inContext: context
                )
                let entity = MovieQueryEntity(
                    movieQuery: query,
                    insertInto: context
                )
                try context.save()
                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}

// MARK: - Enum



// MARK: - Protocol

protocol MoviesQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    )
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, Error>) -> Void
    )
}
