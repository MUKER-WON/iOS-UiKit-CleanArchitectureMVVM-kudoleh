//
//  PosterImagesRepository.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import Foundation

protocol PosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
