//
//  WebViewController.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL?
    
    var repoLinkWebView: WKWebView = {
        var webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(repoLinkWebView)
        guard let url = url else { return }
        let request = URLRequest(url: url)
        repoLinkWebView.load(request)
        setupConstraints()
    }
    
    func setupConstraints() {
        repoLinkWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        repoLinkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        repoLinkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        repoLinkWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}
