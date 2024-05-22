//
//  MoviesSceneDIContainer.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import UIKit
import SwiftUI

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
    
    // MARK: - UseCase
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository(),
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    func makeFetchRecentMovieQueriesUseCase(
        requestValue: FetchRecentMovieQueriesUseCase.RequestValue,
        completion: 
        @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchRecentMovieQueriesUseCase(
            requestValue: requestValue,
            completion: completion,
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    // MARK: - Repositories
    
    func makeMoviesRepository() -> MoviesRepository {
        DefaultMoviesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        DefaultMoviesQueriesRepository(
            moviesQueriesPersistentStorage: moviesQueriesStorage
        )
    }
    
    func makePosterImagesRepository() -> PosterImagesRepository {
        DefaultPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }
    
    // MARK: - Movies List
    
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions
    ) -> MoviesListViewController {
        MoviesListViewController(
            viewModel: makeMoviesListViewModel(actions: actions),
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    func makeMoviesListViewModel(
        actions: MoviesListViewModelActions
    ) -> MoviesListViewModel {
        DefaultMoviesListViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Movie Details
    
    func makeMoviesDetailsViewController(
        movie: Movie
    ) -> UIViewController {
        MovieDetailsViewcontroller(
            viewModel: makeMoviesDetailsViewModel(movie: movie)
        )
    }
    
    func makeMoviesDetailsViewModel(
        movie: Movie
    ) -> MovieDetailsViewModel {
        DefaultMovieDetailsViewModel(
            movie: movie,
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    // MARK: - Movies Queries Suggestions List
    
    func makeMoviesQueriesSuggestionsLIstViewController(
        didSelect:
        @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = MoviesQueryListView(
//                viewModelWrapper: makeMoviesQueryListViewModelWrapper(
//                    didSelect: didSelect
//                )
//            )
//            return UIHostingController(rootView: view)
//        } else { // UIKit }
        return MoviesQueriesTableViewController(
            viewModel: makeMoviesQueryListViewModel(
                didSelect: didSelect
            )
        )
    }

    
    func makeMoviesQueryListViewModel(
        didSelect:
        @escaping MoviesQueryListViewModelDidSelectAction
    ) -> MoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: 10,
            fetchRecentMovieQueriesUseCaseFactory:
                makeFetchRecentMovieQueriesUseCase,
            didSelect: didSelect
        )
    }

    @available(iOS 13.0, *)
    func makeMoviesQueryListViewModelWrapper(
        didSelect: 
        @escaping MoviesQueryListViewModelDidSelectAction
    ) -> MoviesQueryListViewModelWrapper {
        MoviesQueryListViewModelWrapper(
            viewModel: makeMoviesQueryListViewModel(
                didSelect: didSelect
            )
        )
    }
    
    // MARK: - Flow Coordinators
    
    func makeMoviesSearchFlowCoordinator(
        navigationController: UINavigationController
    ) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
