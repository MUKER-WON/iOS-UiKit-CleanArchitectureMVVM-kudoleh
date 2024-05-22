//
//  MoviesSearchFlowCoordinator.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import UIKit

final class MoviesSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: MoviesSearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    
}

// MARK: - Extention



// MARK: - Enum



// MARK: - Protocol

protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions
    ) -> MoviesListViewController
    func makeMoviesDetailsViewController(
        movie: Movie
    ) -> UIViewController
    func makeMoviesQueriesSuggestionsLIstViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController
}
