//
//  MoviesListViewModel.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

final class DefaultMoviesListViewModel: MoviesListViewModel {
    private let searchMoviesUseCase: SearchMoviesUseCase
    private let actions: MoviesListViewModelActions?
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool {
        currentPage < totalPageCount
    }
    var nextPage: Int {
        hasMorePages ? currentPage + 1 : currentPage
    }
    private var pages: [MoviesPage] = []
    private var moviesLoadTask: Cancellable? {
        willSet {
            moviesLoadTask?.cancel()
        }
    }
    private let mainQueue: DispatchQueueType
    
    // MARK: - Output
    
    var items: Observable<[MoviesListItemViewModel]> = Observable([])
    var loading: Observable<MoviesListViewModelLoading?> = Observable(.none)
    var query: Observable<String> = Observable("")
    var error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    var screenTitle = NSLocalizedString(
        "Movies",
        comment: ""
    )
    var emptyDataTitle = NSLocalizedString(
        "Search results",
        comment: ""
    )
    var errorTitle = NSLocalizedString(
        "Error",
        comment: ""
    )
    var searchBarPlaceholder = NSLocalizedString(
        "Search Movies",
        comment: ""
    )
    
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        actions: MoviesListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    private func appendPage(_ moviesPage: MoviesPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPages
        pages = pages.filter {
            $0.page != moviesPage.page
        } + [moviesPage]
        items.value = pages.movies.map(MoviesListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(
        movieQuery: MovieQuery,
        loading: MoviesListViewModelLoading
    ) {
        self.loading.value = loading
        query.value = movieQuery.query
        moviesLoadTask = searchMoviesUseCase.execute(
            requestValue: .init(
                query: movieQuery,
                page: nextPage
            ),
            cached: { [weak self] page in
                self?.mainQueue.async {
                    self?.appendPage(page)
                }
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        self?.appendPage(page)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                    self?.loading.value = .none
                }
            }
        )
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError
        ? NSLocalizedString(
            "No internet connection",
            comment: ""
        )
        : NSLocalizedString(
            "Failed loading movies",
            comment: ""
        )
    }
    
    private func update(movieQuery: MovieQuery) {
        resetPages()
        load(
            movieQuery: movieQuery,
            loading: .fullScreen
        )
    }
    
    // MARK: - Input
    func viewDidLoad() {
        
    }
    
    func didLoadNextPage() {
        guard hasMorePages,
              loading.value == .none
        else { return }
        load(
            movieQuery: .init(query: query.value),
            loading: .nextPage
        )
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(movieQuery: MovieQuery(query: query))
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        actions?.showMovieQueriesSuggestions(update(movieQuery:))
    }
    
    func closeQueriesSuggestions() {
        actions?.closeMovieQueriesSuggestions()
    }
    
    func didSelectItem(at index: Int) {
        actions?.showMovieDetails(pages.movies[index])
    }
}

// MARK: - MoviesListViewModelActions

struct MoviesListViewModelActions {
    let showMovieDetails: (Movie) -> Void
    let showMovieQueriesSuggestions:
    (@escaping (_ didSelect: MovieQuery) -> Void) -> Void
    let closeMovieQueriesSuggestions: () -> Void
}

// MARK: - Extention


// MARK: - Enum

enum MoviesListViewModelLoading {
    case fullScreen
    case nextPage
}

// MARK: - Protocol

protocol MoviesListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol MoviesListViewModelOutput {
    var items: Observable<[MoviesListItemViewModel]> { get }
    var loading: Observable<MoviesListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol MoviesListViewModel: MoviesListViewModelInput,
                              MoviesListViewModelOutput {
    
}
