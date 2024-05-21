//
//  MoviesRequestDTO.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
