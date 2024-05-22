//
//  CGSize+.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(
            width: width * UIScreen.main.scale,
            height: height * UIScreen.main.scale
        )
    }
}
