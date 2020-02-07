//
//  ViewController.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit

extension SearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        self.viewModel.newSearch(searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.searchView.searchResultsTableView.reloadData()
            }
        }
    }
}

final class SearchResultsController: UIViewController {
    
    let viewModel = UserSearchViewModel()
    let searchView = SearchView()
    private var errorState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchView
        self.setupSearchBar()
        
        searchView.viewModel = viewModel
        searchView.controller = self
    }
    
    
    private func showError() {
        guard !self.errorState else { return }
        self.errorState = true
        let alert = UIAlertController(title: "Warning", message: "Rate limit exceeded", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.errorState = false
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = self.viewModel.searchPlaceholderText
        self.navigationItem.searchController = searchController
    }
}

