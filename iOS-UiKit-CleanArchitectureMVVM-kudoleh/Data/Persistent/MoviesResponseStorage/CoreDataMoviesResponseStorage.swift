//
//  MoviesResponseStorage.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation
import CoreData

final class CoreDataMoviesResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(
        coreDataStorage: CoreDataStorage = CoreDataStorage.shared
    ) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func fetchRequest(
        for requestDTO: MoviesRequestDTO
    ) -> NSFetchRequest<MoviesRequestEntity> {
        let request = MoviesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(
            // %K = %@ <- 키경로와 값이 일치해야 함
            // AND <- 두조건 모두 다 참
            // %K = %d <- 키경로와 정수 값이 일치해야 함
            format: "%K = %@ AND %K = %d",
            #keyPath(MoviesRequestEntity.query),
            requestDTO.query,
            #keyPath(MoviesRequestEntity.page),
            requestDTO.page
        )
        return request
    }
    
    private func deleteResponse(
        for requestDTO: MoviesRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDTO)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Extention

extension CoreDataMoviesResponseStorage: MoviesResponseStorage {
    
    func getResponse(
        for requestDTO: MoviesRequestDTO,
        completion: 
        @escaping (Result<MoviesResponseDTO?, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDTO)
                let requestEntity =
                try context.fetch(fetchRequest).first
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(
                    .failure(CoreDataStorageError.readError(error))
                )
            }
        }
    }
    
    func save(
        response responseDTO: MoviesResponseDTO,
        for requestDTO: MoviesRequestDTO
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(
                    for: requestDTO,
                    in: context
                )
                let requestEntity = requestDTO.toEntity(in: context)
                requestEntity.response =
                responseDTO.toEntity(in: context)
                try context.save()
            } catch {
                debugPrint("CoreDataMoviesResponseStorage 에러: \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

// MARK: - Enum



// MARK: - Protocol

protocol MoviesResponseStorage {
    func getResponse(
        for request: MoviesRequestDTO,
        completion: @escaping (
            Result<MoviesResponseDTO?, Error>
        ) -> Void
    )
    
    func save(
        response: MoviesResponseDTO,
        for requestDTO: MoviesRequestDTO
    )
}
