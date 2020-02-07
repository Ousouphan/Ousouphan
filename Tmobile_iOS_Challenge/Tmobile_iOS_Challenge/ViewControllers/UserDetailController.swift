//
//  UserDetailViewController.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit

final class UserDetailController: UIViewController {

    var viewModel: UserViewModel!
    var userDetailView = UserDetailView()
    
    private var operationQueue = OperationQueue()
    private var imageOp: ImageLoadOp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = userDetailView
        
        userDetailView.viewModel = viewModel
        userDetailView.controller = self
        userDetailView.getImage()
        userDetailView.setupTableView()
        
        self.setupLabels()
        self.viewModel.getRepositories(with: nil) { [weak self] in
            DispatchQueue.main.async {
                self?.userDetailView.repoTableView.reloadData()
            }
        }
    }
    
    private func setupLabels() {
        userDetailView.usernameLabel.text = "Username: \(self.viewModel.username)"
        userDetailView.emailLabel.text = "Email: \(self.viewModel.userEmail ?? "No Email")"
        userDetailView.locationLabel.text = "Location: \(self.viewModel.userLocation ?? "No Location")"
        userDetailView.dateLabel.text = "Join Date: \(self.viewModel.dateOfJoining)"
        userDetailView.followersLabel.text = "\(self.viewModel.followersCount) Followers"
        userDetailView.followingLabel.text = "Following \(self.viewModel.followingCount)"
        userDetailView.bioLabel.text = self.viewModel.userBiography
    }
}
