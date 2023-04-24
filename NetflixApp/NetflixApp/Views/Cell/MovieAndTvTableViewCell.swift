//
//  MovieAndTvTableViewCell.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 21.04.2023.
//

import UIKit
import SDWebImage

class MovieAndTvTableViewCell: UITableViewCell {

   static let identifier = "MovieAndTvTableViewCell"
    
    // Views
    
    private let playTitleButton : UIButton = {
        
        let button                                       = UIButton()
        let image                                        = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 5))
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor                                 = .white
        return button
        
    }()
    
    private let titleLabel : UILabel = {
        
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let posterImageView : UIImageView = {
        
        let imageView                                       = UIImageView()
        imageView.contentMode                               = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds                             = true
        return imageView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    
    //Initialize
    
    private func initialize(){
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }
    
    // Set ImageView Position and Size
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame.size = CGSize(width: 105, height: 150)
    }

    // Constraints
    
    private func applyConstraints(){
        
        let posterImageViewConstraints =
        [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        
        ]
        
        let titleLabelConstraints =
        [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playTitleButtonConstraints =
        [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    // Configure ImageView and TitleLabel

    public func configure(with model: ModelAndTvViewModel){

        guard let url   = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
