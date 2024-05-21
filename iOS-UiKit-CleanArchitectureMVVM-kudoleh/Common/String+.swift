//
//  String+.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

extension String {
    func convertDate() -> Date? {
        return DateFormatter.formatter.date(from: self)
    }
}
