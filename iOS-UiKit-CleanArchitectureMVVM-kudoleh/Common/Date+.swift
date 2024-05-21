//
//  Date+.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import Foundation

extension Date {
    func convertString(
        format: String = "yyyy-MM-dd"
    ) -> String? {
        let dateFormatter = DateFormatter.formatter
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
