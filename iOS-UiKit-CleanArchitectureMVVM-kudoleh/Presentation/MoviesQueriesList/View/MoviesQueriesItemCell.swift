//
//  MoviesQueriesItemCell.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class MoviesQueriesItemCell: UITableViewCell {
    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: MoviesQueriesItemCell.self)

    private let titleLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    func fill(with suggestion: MoviesQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }
}

