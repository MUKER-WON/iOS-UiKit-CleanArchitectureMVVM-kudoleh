//
//  MoviesQueryListView.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import SwiftUI

struct MoviesQueryListView: View {
    @ObservedObject var viewModelWrapper: MoviesQueryListViewModelWrapper
    
    var body: some View {
        List(viewModelWrapper.items) { item in
            Button(action: {
                self.viewModelWrapper.viewModel?.didSelect(item: item)
            }) {
                Text(item.query)
            }
        }
        .onAppear {
            self.viewModelWrapper.viewModel?.viewWillAppear()
        }
    }
}

// MARK: - MoviesQueryListViewModelWrapper

final class MoviesQueryListViewModelWrapper: ObservableObject {
    var viewModel: MoviesQueryListViewModel?
    @Published var items: [MoviesQueryListItemViewModel] = []
    
    init(viewModel: MoviesQueryListViewModel?) {
        self.viewModel = viewModel
        viewModel?.items.observe(on: self) { [weak self] values in self?.items = values }
    }
}

// MARK: - Extention

extension MoviesQueryListItemViewModel: Identifiable { }

// MARK: - Enum

// MARK: - Protocol


