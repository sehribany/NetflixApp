//
//  SearchResultsViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 22.04.2023.
//

import UIKit

// Protocol

protocol SearchResultsViewControllerDelegate : AnyObject {
    
    func searchResultsViewControllerDidTapItem(_ viewModel : TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var titles        : [Title] = [Title]()
    
    public weak var delegate : SearchResultsViewControllerDelegate?

    // Views
    
    public let searchResultsViewController : UICollectionView = {
        
        let layout                     = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieAndTvCollectionViewCell.self, forCellWithReuseIdentifier: MovieAndTvCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        
        view.backgroundColor = .systemGreen
        view.addSubview(searchResultsViewController)
        
        searchResultsViewController.delegate   = self
        searchResultsViewController.dataSource = self
        
    }

    // Set ViewController Position and Size
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsViewController.frame = view.bounds
    }
    
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieAndTvCollectionViewCell.identifier, for: indexPath) as? MovieAndTvCollectionViewCell else{return UICollectionViewCell()}
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path )
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
