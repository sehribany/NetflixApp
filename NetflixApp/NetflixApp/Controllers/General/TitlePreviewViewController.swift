//
//  TitlePreviewViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 24.04.2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    // Views
    
    private let titleLabel : UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = .systemFont(ofSize: 22, weight: .bold)
        label.text                                      = "Harry potter"
        return label
        
    }()
    
    private let overviewLabel : UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines                             = 0
        label.text                                      = "This is the best movie ever to watch as a kid!"
        return label
        
    }()
    
    private let downloadButton : UIButton = {
        
        let button                                       = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor                           = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius                        = 10
        button.layer.masksToBounds                       = true
        return button
        
    }()
    
    private let webView : WKWebView = {
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }
    

    // Initialize
    
    func initialize(){
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        view.addSubview(webView)
        
        self.configureConstraint()
    }
    
    // Constraints
    
    func configureConstraint(){
        
        let webViewConstraints =
        [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints =
        [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ]
        
        let overviewLabelConstraints =
        [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints =
        [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
    // Configure TitleLabel, OverViewLabel and WebView
    
    func configure(with model : TitlePreviewViewModel){
        
        titleLabel.text    = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url      = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
