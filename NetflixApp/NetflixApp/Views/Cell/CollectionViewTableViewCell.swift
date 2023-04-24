//
//  CollectionViewTableViewCell.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import UIKit

// Protocol

protocol CollectionViewTableViewCellDelegate : AnyObject {
    
    func collectionViewTableViewDidTapCell( _ cell: CollectionViewTableViewCell, viewModel : TitlePreviewViewModel)
    
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier       = "CollectionViewTableViewCell"
    
    weak var delegate           : CollectionViewTableViewCellDelegate?
    
    private var titles          : [Title] = [Title]()
    
    // Vİews
    
    private let collectionView : UICollectionView = {
        
        let layout             = UICollectionViewFlowLayout()
        layout.itemSize        = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView     = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieAndTvCollectionViewCell.self, forCellWithReuseIdentifier: MovieAndTvCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Set CollectionView Position and Size
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // Update Data
    public func configureMovie(with titles : [Title]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            
            self?.collectionView.reloadData()
            
        }
    }
    
    // Download Data to Local Database
    
    private func downloadTitleAt(indexPath: IndexPath){
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieAndTvCollectionViewCell.identifier, for: indexPath) as! MovieAndTvCollectionViewCell
            cell.configure(with: titles[indexPath.row].poster_path)
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else { return }
                guard let strongSelf = self else { return }
                
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){ _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.downloadTitleAt(indexPath: indexPath)
                
            }
            return UIMenu(title: "", image: nil, identifier: nil,options: .displayInline, children: [downloadAction])
    
        }
        return config
    }
}
