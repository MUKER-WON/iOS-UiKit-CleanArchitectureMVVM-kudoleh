//
//  MoviewsListItemViewModel.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

struct MoviesListItemViewModel: Equatable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterImagePath: String?
    
    init(movie: Movie) {
        self.title = movie.title ?? "제목 없음"
        self.overview = movie.overview ?? "개요 없음"
        self.releaseDate = movie.releaseDate?.convertString()
        ?? "개봉날짜 없음"
        self.posterImagePath = movie.posterPath
    }
}

// MARK: - Extention

extension MoviesListItemViewModel {
    
}

// MARK: - Enum

// MARK: - Protocol


