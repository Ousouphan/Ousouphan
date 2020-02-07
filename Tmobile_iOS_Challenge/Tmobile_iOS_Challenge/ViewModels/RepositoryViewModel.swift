//
//  RepositoryViewModel.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation

final class RepositoryViewModel {
    
    init(repo: Repository) {
        self.repository = repo
    }
    
    private let repository: Repository
    
    var repoURL: URL {
        return self.repository.htmlURL
    }
    
    var repoName: String {
        return self.repository.name
    }
    
    var forksCount: Int {
        return self.repository.forks
    }
    
    var starsCount: Int {
        return self.repository.stars
    }
}
