//
//  UserSearchCell.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    private var imageOperation: ImageLoadOp?
    private let operationQueue = OperationQueue()
    
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var userImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()
    
    var repoCountLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: UserViewModel?) {
      guard let viewModel = viewModel else {
        self.userImageView.image = nil
        self.userImageView.backgroundColor = .black
        self.usernameLabel.text = ""
        self.repoCountLabel.text = ""
        return
      }
      self.usernameLabel.text = viewModel.username
      self.repoCountLabel.text = "Repos: \(viewModel.repoCount)"
      guard let imageURL = viewModel.pictureURL else { return }
      let imageOperation = ImageLoadOp(imageURL: imageURL)
      imageOperation.update(self.updateWithImage(_:))
        self.imageOperation = imageOperation
      self.operationQueue.addOperation(imageOperation)
    }
    
    private func updateWithImage(_ image: UIImage) {
      DispatchQueue.main.async { [weak self] in
        self?.userImageView.image = image
        self?.userImageView.backgroundColor = .clear
      }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      self.imageOperation?.cancel()
      self.imageOperation = nil
    }
    
    func setupView() {
        backgroundColor = .black
        addSubview(usernameLabel)
        addSubview(userImageView)
        addSubview(repoCountLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            userImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3),
            userImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
            
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            usernameLabel.trailingAnchor.constraint(equalTo: repoCountLabel.leadingAnchor, constant: 0),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            repoCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            repoCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
}
