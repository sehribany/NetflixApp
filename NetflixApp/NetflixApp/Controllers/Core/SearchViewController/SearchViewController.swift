//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles : [Title] = [Title]()
    
    // Views
    
    public let discoverTable : UITableView = {
        
        let table = UITableView()
        table.register(MovieAndTvTableViewCell.self, forCellReuseIdentifier: MovieAndTvTableViewCell.identifier)
        return table
        
    }()
    
    private let searchController : UISearchController = {
        
        let controller                      = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder    = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        view.backgroundColor = .systemBackground
        title                                                      = "Search"
        navigationController?.navigationBar.prefersLargeTitles     = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.dataSource = self
        discoverTable.delegate   = self
        
        navigationItem.searchController               = searchController
        navigationController?.navigationBar.tintColor = .white
        
        self.fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
        
    }
    
    // Search API
    
    private func fetchDiscoverMovies(){
        
        APICaller.shared.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Set TableView Position and Size
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
  

}
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieAndTvTableViewCell.identifier, for: indexPath) as? MovieAndTvTableViewCell else{return UITableViewCell()}
        
        let title = titles[indexPath.row]
        cell.configure(with: ModelAndTvViewModel(titleName: (title.original_name ?? title.original_title ) ?? "unknow" , posterURL: title.poster_path ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController : UISearchResultsUpdating , SearchResultsViewControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else{ return }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsViewController.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
