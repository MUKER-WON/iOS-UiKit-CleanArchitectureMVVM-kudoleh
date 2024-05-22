//
//  MoviesQueriesTableViewController.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/22/24.
//

import UIKit

final class MoviesQueriesTableViewController: UITableViewController {
    private var viewModel: MoviesQueryListViewModel
    
    init(
        viewModel: MoviesQueryListViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    private func configureUI() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = MoviesQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bind(to viewModel: MoviesQueryListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

// MARK: - Extention

extension MoviesQueriesTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MoviesQueriesItemCell.reuseIdentifier, for: indexPath) as? MoviesQueriesItemCell
        else {
            assertionFailure("Cannot dequeue reusable cell \(MoviesQueriesItemCell.self) with reuseIdentifier: \(MoviesQueriesItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: false
        )
        viewModel.didSelect(
            item: viewModel.items.value[indexPath.row]
        )
    }
}

// MARK: - Enum

// MARK: - Protocol



