//
//  DefaultPosterImagesRepository.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

final class DefaultPosterImagesRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue =
        DispatchSerialQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

// MARK: - Extention

extension DefaultPosterImagesRepository: PosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = APIEndPoints.getMoviePoster(
            path: imagePath,
            width: width
        )
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(
            with: endPoint,
            on: backgroundQueue
        ) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            completion(result)
        }
        return task
    }
}



// MARK: - Enum



// MARK: - Protocol


