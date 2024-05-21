//
//  MoviesSceneDIContainer.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import UIKit

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    lazy var moviesQueriesStorage: MoviesQueriesStorage =
    CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: MoviesResponseStorage =
    CoreDataMoviesResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
