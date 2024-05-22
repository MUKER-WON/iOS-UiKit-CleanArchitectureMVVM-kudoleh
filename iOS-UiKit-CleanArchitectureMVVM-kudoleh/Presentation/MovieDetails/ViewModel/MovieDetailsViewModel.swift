//
//  MovieDetailsViewModel.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    private let posterImagePath: String?
    private let posterImagesRepository: PosterImagesRepository
    private var imageLoadTask: Cancellable? {
        willSet {
            imageLoadTask?.cancel()
        }
    }
    private let mainQueue: DispatchQueueType
    
    // MARK: - Output
    
    var title: String
    var posterImage: Observable<Data?> = Observable(nil)
    var isPosterImageHidden: Bool
    var overview: String
    
    init(
        movie: Movie,
        posterImagesRepository: PosterImagesRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.title = movie.title ?? "제목 없음"
        self.overview = movie.overview ?? "개요 없음"
        self.posterImagePath = movie.posterPath
        self.isPosterImageHidden = movie.posterPath == nil
        self.posterImagesRepository = posterImagesRepository
        self.mainQueue = mainQueue
    }
    
    // MARK: - Input
    
    func updatePosterImage(width: Int) {
        guard let posterImagePath else { return }
        imageLoadTask = posterImagesRepository.fetchImage(
            with: posterImagePath,
            width: width
        ) { [weak self] result in
            self?.mainQueue.async {
                // 다시 또 검사하는 이유: 비동기 작업이 시작될 때의 값과 여전히 동일한지 확인
                guard self?.posterImagePath == posterImagePath else { return }
                switch result {
                case .success(let data):
                    self?.posterImage.value = data
                case .failure(let error):
                    break
                }
                self?.imageLoadTask = nil
            }
        }
    }
}

// MARK: - Extention

// MARK: - Enum

// MARK: - Protocol

protocol MovieDetailsViewModelInput {
    func updatePosterImage(width: Int)
}

protocol MovieDetailsViewModelOutput {
    var title: String { get }
    var posterImage: Observable<Data?> { get }
    var isPosterImageHidden: Bool { get }
    var overview: String { get }
}

protocol MovieDetailsViewModel: MovieDetailsViewModelInput,
                                MovieDetailsViewModelOutput {
    
}
