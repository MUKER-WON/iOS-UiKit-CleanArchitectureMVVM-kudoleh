//
//  APIEndPoints.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

struct APIEndPoints {
    static func getMovies(
        with moviesRequestDTO: MoviesRequestDTO
    ) -> EndPoint<MoviesResponseDTO> {
        return EndPoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: moviesRequestDTO
        )
    }
    
    static func getMoviePoster(
        path: String,
        width: Int
    ) -> EndPoint<Data> {
        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes.enumerated().min {
            abs($0.1 - width) < abs($1.1 - width)
        }?.element ?? sizes.first!
        return EndPoint(
            path: "t/p/w\(closestWidth)\(path)",
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
