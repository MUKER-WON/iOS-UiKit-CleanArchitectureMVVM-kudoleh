//
//  MoviesResponseDTO.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

struct MoviesResponseDTO: Decodable {
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}

// MARK: - Extention

extension MoviesResponseDTO {
    struct MovieDTO: Decodable {
        let id: Int
        let title: String?
        let genre: GenreDTO?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
        
        enum GenreDTO: String, Decodable {
            case adventure
            case scienceFiction = "science_fiction"
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case genre
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_data"
        }
    }
    
    func toDomain() -> MoviesPage {
        return .init(
            page: page,
            totalPages: totalPages,
            movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(
            id: Movie.Identifier(id),
            title: title,
            genre: genre?.toDomain(),
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate?.convertDate()
        )
    }
}

extension MoviesResponseDTO.MovieDTO.GenreDTO {
    func toDomain() -> Movie.Genre {
        switch self {
        case .adventure:
            return .adventure
        case .scienceFiction:
            return .scienceFiction
        }
    }
}
    
// MARK: - Enum
    
    
    
// MARK: - Protocol
    
    
