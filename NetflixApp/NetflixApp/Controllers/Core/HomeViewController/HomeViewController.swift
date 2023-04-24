//
//  HomeViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import UIKit

// Enums

enum Sections : Int{
    
    case TrendingMovies = 0
    case TrendingTv     = 1
    case Popular        = 2
    case UpComing       = 3
    case TopRated       = 4
    
}

class HomeViewController: UIViewController {

    private var randomTrendingMovie : Title?
    private var headerView          : HeroHeaderView?
    
    // Views
    
    let sectionTitles: [String] = ["Trending Movies","Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable : UITableView = {
        
        let table = UITableView(frame: .zero , style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate        = self
        homeFeedTable.dataSource      = self
        
        self.configureNavBar()
        
        headerView                    = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeaderView()
        
    }
    
    // Configure HeaderView
    
    private func configureHeaderView(){
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: ModelAndTvViewModel(titleName: selectedTitle?.title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Configure NavBar
    
    func configureNavBar(){
        
        var image                                     = UIImage(named: "netflixlogo")
        image                                         = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItems             = [UIBarButtonItem(image: image, style: .done, target: self, action: nil)]
        
        navigationItem.rightBarButtonItems            =
        [
            UIBarButtonItem(image: UIImage(systemName: "person"),style: .done,target: self,action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    // Set TableView Position and Size
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { results in
                switch results{
                case .success(let movie):
                    cell.configureMovie(with: movie)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTv { results in
                switch results{
                case .success(let tv):
                    cell.configureMovie(with: tv)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopular { results in
                switch results{
                case .success(let movie):
                    cell.configureMovie(with: movie)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.UpComing.rawValue:
            
            APICaller.shared.getUpcomingMovies { results in
                switch results{
                case .success(let movie):
                    cell.configureMovie(with: movie)
                case .failure(let error):
                    print(error)
                }
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getTopRated{ results in
                switch results{
                case .success(let movie):
                    cell.configureMovie(with: movie)
                case .failure(let error):
                    print(error)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
      
       return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header            = view as?  UITableViewHeaderFooterView else {return}
        header.textLabel?.font      = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame     = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text      = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset                             = view.safeAreaInsets.top
        let offset                                    = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
  
    
}

extension HomeViewController : CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
