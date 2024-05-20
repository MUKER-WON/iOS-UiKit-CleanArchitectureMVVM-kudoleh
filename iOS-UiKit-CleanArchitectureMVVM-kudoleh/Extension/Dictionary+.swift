//
//  Dictionary+.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(
                withAllowedCharacters: NSCharacterSet.urlQueryAllowed
            ) ?? ""
    }
    
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
            ) {
                string = nstr as String
            }
        }
        return string
    }
}
