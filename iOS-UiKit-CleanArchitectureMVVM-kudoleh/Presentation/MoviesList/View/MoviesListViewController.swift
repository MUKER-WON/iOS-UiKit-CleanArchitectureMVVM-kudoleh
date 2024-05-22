//
//  MoviesListViewController.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class MoviesListViewController: UIViewController {
    private var viewModel: MoviesListViewModel
    private let posterImagesRepository: PosterImagesRepository?
    private let searchController =
    UISearchController(searchResultsController: nil)
    
    private let contentView: UIView = {
        var view = UIView()
        return view
    }()
    private let moviesListContainer: UIView = {
        var view = UIView()
        return view
    }()
    private(set) var suggestionsListContainer: UIView = {
        var view = UIView()
        return view
    }()
    private let emptyDataLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    init(
        viewModel: MoviesListViewModel,
        posterImagesRepository: PosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func configureUI() {
        self.title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        
    }

}

// MARK: - Extention

// MARK: - Enum

// MARK: - Protocol


