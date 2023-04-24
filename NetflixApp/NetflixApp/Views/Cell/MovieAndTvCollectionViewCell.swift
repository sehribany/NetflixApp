//
//  MovieAndTvCollectionViewCell.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 20.04.2023.
//

import UIKit
import SDWebImage

class MovieAndTvCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieAndTvCollectionViewCell"
    
    //Views
     
    private let posterImageView : UIImageView = {
        
        let imageView         = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.initialize()
    }
    
    // Initialize
    
    func initialize(){
        contentView.addSubview(posterImageView)
    }
    
    // Set ImageView Position and Size
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure ImageView
    
    public func configure(with model : String){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)

    }
}
