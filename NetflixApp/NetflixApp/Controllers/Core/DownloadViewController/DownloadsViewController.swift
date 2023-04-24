//
//  DownloadsViewController.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import UIKit

class DownloadsViewController: UIViewController {
     
    private var titles : [TitleItem] = [TitleItem]()
    
    // Views
    
    public let downloadTable : UITableView = {
        
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
        
        view.backgroundColor = .systemBackground
        title                                                      = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles     = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTable)
        downloadTable.delegate   = self
        downloadTable.dataSource = self
        
        fetchLocalStrogeForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStrogeForDownload()
        }

    }
    
    // Fetch Loccal Stroge
    private func fetchLocalStrogeForDownload(){
        DataPersistenceManager.shared.fetchingTitlesFromDatabase {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    // Set TableView Position and Size
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
 

}
extension DownloadsViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieAndTvTableViewCell.identifier, for: indexPath) as? MovieAndTvTableViewCell else { return UITableViewCell()}
       
        let title = titles[indexPath.row]
        cell.configure(with: ModelAndTvViewModel(titleName: (title.original_name ?? title.original_title ) ?? "unknow" , posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        switch editingStyle{
        case .delete:
           
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { result in
                switch result{
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break;
        }
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
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}
