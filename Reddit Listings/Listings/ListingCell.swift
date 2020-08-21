//
//  ListingCell.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/18/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import UIKit

class ListingCell: UITableViewCell {

    lazy var thumbnailView: UIImageView! = {
        let _thumbnailView = UIImageView(image: UIImage(named: "Reddit_Logo"))
        _thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        _thumbnailView.contentMode = .scaleAspectFit
        return _thumbnailView
    }()
    
    lazy var titleView: UILabel! = {
        let _titleView = UILabel(frame: .zero)
        _titleView.translatesAutoresizingMaskIntoConstraints = false
        _titleView.text = "Listing Title"
        _titleView.numberOfLines = 3
        _titleView.font = .systemFont(ofSize: 16)
        return _titleView
    }()
    
    lazy var arrowView: UIImageView! = {
        let _arrowView = UIImageView(frame: .zero)
        _arrowView.translatesAutoresizingMaskIntoConstraints = false
        _arrowView.image = UIImage(named: "Right_Arrow")
        _arrowView.contentMode = .scaleAspectFit
        
        return _arrowView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(thumbnailView)
        addSubview(titleView)
        addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(equalTo: heightAnchor, constant: -12),
            thumbnailView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            
            titleView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -6),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 25),
            arrowView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    func setContents(image: UIImage?, title: String?) {
        if let _title = title {
            titleView.text = _title
        }
        thumbnailView?.image = image ?? UIImage(named: "Reddit_Logo")
        setNeedsUpdateConstraints()
    }
}

