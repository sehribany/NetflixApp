//
//  UpcomingViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles        : [Title] = [Title]()

    // Views
    
    private let upcomingTable : UITableView = {
        
        let table = UITableView()
        table.register(MovieAndTvTableViewCell.self, forCellReuseIdentifier: MovieAndTvTableViewCell.identifier)
        return table
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        title                                                      = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles     = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate   = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
        
    }
    
    // Set TableView Position and Size
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    // Upcoming API
    
    private func fetchUpcoming(){
        
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}




extension UpcomingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieAndTvTableViewCell.identifier, for: indexPath) as? MovieAndTvTableViewCell else { return UITableViewCell()}
       
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
