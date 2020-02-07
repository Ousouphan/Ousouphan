//
//  UserViewModel.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation

private extension UserViewModel {
    func getRepos(with search: String?, isMore: Bool, completion: @escaping () -> Void) {
        self.session.retriveModel(from: self.getURL(with: search), modelType: RepositoryResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if isMore {
                    self?.repositories += response.items
                } else {
                    self?.repositories = response.items
                }
            case .failure(let error):
                self?.currentError = error
            }
            completion()
        }
    }
    
    func getURL(with term: String?) -> String {
        guard let name = self.user.login.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
        defer { self.page += 1 }
        if let term = term {
            return "https://api.github.com/search/repositories?q=\(term)+user:\(name)&page=\(self.page)"
        } else {
            return "https://api.github.com/search/repositories?q=user:\(name)&page=\(self.page)"
        }
    }
}

final class UserViewModel {
    
    private let user: User
    private let session: Session
    private var repositories: [Repository] = []
    private var page = 1
    private var currentError: Error?
    private var searchTerm: String?
    private var timerForSearch: Timer?
    
    init(user: User, session: Session = NetworkManager.shared) {
        self.user = user
        self.session = session
    }
    
    var repoCount: Int {
        return self.user.numberOfPublicRepos
    }
    
    var numberOfRepos: Int {
        return self.repositories.count
    }
    
    var pictureURL: String? {
        return self.user.avatarURL
    }
    
    var username: String {
        return self.user.name ?? "Name not available"
    }
    
    var userEmail: String? {
        return self.user.email
    }
    
    var userLocation: String? {
        return self.user.location
    }
    
    var dateOfJoining: String {
        return self.user.joinDate
    }
    
    var followersCount: Int {
        return self.user.numberOfFollowers
    }
    
    var followingCount: Int {
        return self.user.numberFollowing
    }
    
    var userBiography: String? {
        return self.user.biography
    }
    
    func repoViewModel(for index: Int)-> RepositoryViewModel {
        return RepositoryViewModel(repo: self.repositories[index])
    }
    
    func getRepositories(with search: String?, isMore: Bool = false, completion: @escaping () -> Void) {
        if search != self.searchTerm {
            self.page = 1
        }
        self.searchTerm = search
        if self.searchTerm != nil && !isMore {
            self.timerForSearch?.invalidate()
            self.timerForSearch = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
                self?.getRepos(with: search, isMore: isMore, completion: completion)
            })
        } else {
            self.getRepos(with: search, isMore: isMore, completion: completion)
        }
    }
}
