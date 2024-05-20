//
//  AppConfiguration.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/20/24.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "APIKey"
        ) as? String
        else {
            fatalError("plist에서 APIKey를 찾을 수 없습니다.")
        }
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(
            forInfoDictionaryKey: "APIBaseURL"
        ) as? String
        else {
            fatalError("plist에서 APIBaseURL을 찾을 수 없습니다.")
        }
        return apiBaseURL
    }()
    
    lazy var imageBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(
            forInfoDictionaryKey: "ImageBaseURL"
        ) as? String 
        else {
            fatalError("plist에서 APIBaseURL을 찾을 수 없습니다.")
        }
        return imageBaseURL
    }()
}
