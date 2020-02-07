//
//  UserDetailView.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit
import SafariServices

extension UserDetailView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.getRepositories(with: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.repoTableView.reloadData()
            }
        }
    }
}

extension UserDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRepos ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RepoCell ,let repoViewModel = self.viewModel?.repoViewModel(for: indexPath.row) else { return UITableViewCell() }
        
        cell.configure(with: repoViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = self.viewModel?.repoViewModel(for: indexPath.row).repoURL else { return }
        
        let webViewController = WebViewController()
        webViewController.url = url
        controller?.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

class UserDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: UserViewModel?
    weak var controller: UserDetailController?
    
    private var operationQueue = OperationQueue()
    private var imageOperation: ImageLoadOp?
    
    var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var emailLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var followersLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var followingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var locationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var bioLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var repoSearchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var repoTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    func setupView() {
        backgroundColor  = .black
        addSubviews(views: repoSearchBar, profileImageView, usernameLabel, emailLabel, dateLabel, followersLabel, followingLabel,repoTableView, locationLabel, bioLabel)
        
        setupSearchBar()
        setupConstraints()
    }
    
    func setupTableView() {
        self.repoTableView.dataSource = self
        self.repoTableView.delegate = self
        self.repoTableView.register(RepoCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupSearchBar() {
        self.repoSearchBar.delegate = self
        self.repoSearchBar.placeholder = "Search for User's Repositories"
    }
    
    func getImage() {
        guard let avatarImageURL = viewModel?.pictureURL else { return }
        let imageOperation = ImageLoadOp(imageURL: avatarImageURL)
        imageOperation.update { image in
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.profileImageView.contentMode  = .scaleAspectFit
            }
        }
        self.imageOperation = imageOperation
        self.operationQueue.addOperation(imageOperation)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            repoSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            repoSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            repoSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            profileImageView.topAnchor.constraint(equalTo: repoSearchBar.bottomAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            profileImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            dateLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            followersLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            followersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            followersLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            followingLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 5),
            followingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            followingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            locationLabel.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            bioLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            repoTableView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5),
            repoTableView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            repoTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            repoTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}
