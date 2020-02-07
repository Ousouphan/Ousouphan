//
//  UserSearchViewModel.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation

private extension UserSearchViewModel {
    
    func parseResponse(_ result: Result<UserResponse, Error>) {
        switch result {
        case .success(let userResponse):
            self.ListOfUsers += userResponse.items
        case .failure(let error):
            self.currentError = error
        }
    }
    
    func cancelOps() {
        for (index, operation) in self.operations {
            operation.cancel()
            self.operations[index] = nil
        }
    }
    
    func getPageURL() -> String? {
        guard let currentSearchTerm = self.currentSearchTerm else { return nil }
        defer { self.currentPage += 1 }
        return "https://api.github.com/search/users?q=\(currentSearchTerm)&page=\(self.currentPage)"
    }
    
    func createTimer(_ searchCompletion: @escaping () -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            self?.refreshSearchResults(searchCompletion)
        }
    }
}

fileprivate extension UserSearchViewModel {
    func createOperation(_ index: IndexPath) {
        let modelToUse = self.ListOfUsers[index.row]
        let newOperation = UserSearchOp(userURLString: modelToUse.userURL, session: self.currentSession)
        self.operations[index] = newOperation
        self.operationQueue.addOperation(newOperation)
    }
}

final class UserSearchViewModel {
    
    init(session: Session = NetworkManager.shared) {
        self.currentSession = session
    }
    
    private var timer: Timer?
    private var currentSearchTerm: String?
    private let currentSession: Session
    private var currentPage = 1
    
    private let operationQueue = OperationQueue()
    private var operations = [IndexPath: UserSearchOp]()
    private var currentError: Error?
    private var ListOfUsers = [SingleUserResponse]()
    
    private var userViewModels = [IndexPath: UserViewModel]()
    
    var searchPlaceholderText: String {
        return "Search Users"
    }
    
    var hasError: Bool {
        return currentError != nil
    }
    
    var numberOfUsers: Int {
        return self.ListOfUsers.count
    }
    
    func retrieveUser(at index: IndexPath, success: @escaping (UserViewModel) -> Void, error: @escaping (Error) -> Void) {
        if let operation = self.operations[index] {
            operation.update { [weak self] viewModel in
                self?.userViewModels[index] = viewModel
                success(viewModel)
            }
            operation.updateError(error)
        } else {
            self.createOperation(index)
            self.retrieveUser(at: index, success: success, error: error)
        }
    }
    
    func userViewModel(for index: IndexPath) -> UserViewModel? {
        return self.userViewModels[index]
    }
    
    func fetchUsers(for indexPaths: [IndexPath]) {
        for index in indexPaths where self.operations[index] == nil {
            self.createOperation(index)
        }
    }
    
    func cancelUserFetch(for indexPaths: [IndexPath]) {
        for index in indexPaths {
            guard let operation = self.operations[index] else { break }
            operation.cancel()
            self.operations[index] = nil
        }
    }
    
    func newSearch(_ searchTerm: String, searchCompletion: @escaping () -> Void) {
        self.currentPage = 1
        self.cancelOps()
        self.currentSearchTerm = searchTerm
        self.timer?.invalidate()
        self.ListOfUsers = []
        searchCompletion()
        self.timer = createTimer(searchCompletion)
    }
    
    func refreshSearchResults(_ completion: @escaping () -> Void) {
        guard let userSearchURL = self.getPageURL() else { return }
        self.currentSession.retriveModel(from: userSearchURL, modelType: UserResponse.self) { [weak self] result in
            self?.parseResponse(result)
            completion()
        }
    }
}
