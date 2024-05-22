//
//  MoviesListItemCell.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class MoviesListItemCell: UITableViewCell {
    static let reuseIdentifier =
    String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)
    
    private var viewModel: MoviesListItemViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var imageLoadTask: Cancellable? {
        willSet { imageLoadTask?.cancel() }
    }
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    private let dateLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    private let overviewLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    private let posterImageView: UIImageView = {
        var view = UIImageView()
        return view
    }()
    
    // 함수로 초기화
    func fill(
        with viewModel: MoviesListItemViewModel,
        posterImagesRepository: PosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        updatePosterImage(
            width: Int(posterImageView
                .imageSizeAfterAspectFit
                .scaledSize.width
            )
        )
    }
    
    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        guard let posterImagePath = viewModel.posterImagePath
        else { return }
        
        imageLoadTask = posterImagesRepository?.fetchImage(
            with: posterImagePath,
            width: width
        ) { [weak self] result in
            self?.mainQueue.async {
                guard self?.viewModel.posterImagePath == posterImagePath
                else { return }
                if case let .success(data) = result {
                    self?.posterImageView.image = UIImage(data: data)
                }
                self?.imageLoadTask = nil
            }
        }
    }
}
