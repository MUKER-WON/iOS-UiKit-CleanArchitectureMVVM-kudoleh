//
//  MovieDetailsViewcontroller.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class MovieDetailsViewcontroller: UIViewController {
    private let viewModel: MovieDetailsViewModel
    
    private let posterImageView: UIImageView = {
        var view = UIImageView()
        return view
    }()
    private let overviewTextView: UITextView = {
        var view = UITextView()
        return view
    }()
    
    init(
        viewModel: MovieDetailsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.title = viewModel.title
        overviewTextView.text = viewModel.overview
        posterImageView.isHidden = viewModel.isPosterImageHidden
    }
}

// MARK: - Extention

// MARK: - Enum

// MARK: - Protocol


