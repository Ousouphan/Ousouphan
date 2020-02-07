//
//  SearchView.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit

extension SearchView: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfUsers ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserSearchCell else { return UITableViewCell() }
        cell.configure(with: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel?.userViewModel(for: indexPath) else { return }
        let detailsViewController = UserDetailController()
        detailsViewController.viewModel = viewModel
        controller?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserSearchCell else { return }
        let lastRow = (self.viewModel?.numberOfUsers ?? 0) - 1
        if indexPath.row == lastRow {
            
            self.viewModel?.refreshSearchResults {
                let newNumberOfRows = (self.viewModel?.numberOfUsers ?? 0) - 1
                let newIndexPaths = Array((lastRow + 1)...newNumberOfRows).map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async {
                    self.searchResultsTableView.insertRows(at: newIndexPaths, with: .automatic)
                }
            }
        }

        self.viewModel?.retrieveUser(at: indexPath, success: { userViewModel in
            DispatchQueue.main.async {
                cell.configure(with: userViewModel)
            }
        }) { error in }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel?.cancelUserFetch(for: [indexPath])
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.viewModel?.fetchUsers(for: indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        self.viewModel?.cancelUserFetch(for: indexPaths)
    }
}

class SearchView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: UserSearchViewModel?
    weak var controller: SearchResultsController?
    
    var searchResultsTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func setupView() {
        backgroundColor = .white
        setupTableView()
        addSubview(searchResultsTableView)
        setupConstraints()
    }
    
    func setupTableView() {
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.prefetchDataSource = self
        searchResultsTableView.register(UserSearchCell.self, forCellReuseIdentifier: "cell")
        searchResultsTableView.separatorStyle = .none
        searchResultsTableView.backgroundColor = .black
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchResultsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            searchResultsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            searchResultsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            searchResultsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}
