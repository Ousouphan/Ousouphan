//
//  RepoCell.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .blue
        return label
    }()
    
    var forksLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var starsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        addSubviews(views: nameLabel, forksLabel, starsLabel)
        setupConstraints()
    }
    
    func configure(with viewModel: RepositoryViewModel) {
      nameLabel.text = viewModel.repoName
      forksLabel.text = "\(viewModel.forksCount) Forks"
      starsLabel.text = "\(viewModel.starsCount) Stars"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            forksLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            forksLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            forksLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            starsLabel.leadingAnchor.constraint(equalTo: forksLabel.trailingAnchor, constant: 5),
            starsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            starsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
        ])
    }
}
