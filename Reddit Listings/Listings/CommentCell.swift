//
//  CommentCell.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/20/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    lazy var contextBar: UIView! = {
        let _contextBar = UIView(frame: .zero)
        _contextBar.translatesAutoresizingMaskIntoConstraints = false
        _contextBar.backgroundColor = .lightGray
        
        return _contextBar
    }()
    
    lazy var topBackground: UIView! = {
        let _background = UIView(frame: .zero)
        _background.translatesAutoresizingMaskIntoConstraints = false
        _background.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        
        return _background
    }()
    
    lazy var authorLabel: UILabel! = {
        let _authorLabel = UILabel(frame: .zero)
        _authorLabel.translatesAutoresizingMaskIntoConstraints = false
        _authorLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        return _authorLabel
    }()
    
    lazy var textView: UITextView! = {
        let _textView = UITextView(frame: .zero)
        _textView.translatesAutoresizingMaskIntoConstraints = false
        _textView.isScrollEnabled = true
        _textView.isEditable = false
        _textView.font = UIFont.systemFont(ofSize: 14)
        
        return _textView
    }()
    
    private var _indentIndex: Int = 0
    
    var leadingConstraint: NSLayoutConstraint?
    
    var indentIndex: Int {
        set {
            _indentIndex = newValue > 7 ? 7 : newValue
            guard leadingConstraint != nil else {return}
            NSLayoutConstraint.deactivate([leadingConstraint!])
            setNeedsUpdateConstraints()
            
        } get {
            return _indentIndex
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contextBar)
        addSubview(topBackground)
        addSubview(authorLabel)
        addSubview(textView)
    }
    
    override func updateConstraints() {
        leadingConstraint =
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6 + indentForIndex())
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            authorLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            
            contextBar.widthAnchor.constraint(equalToConstant: 4),
            contextBar.heightAnchor.constraint(equalTo: heightAnchor),
            contextBar.trailingAnchor.constraint(equalTo: topBackground.leadingAnchor, constant: -12),
            contextBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            topBackground.topAnchor.constraint(equalTo: topAnchor),
            topBackground.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 6),
            topBackground.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -6),
            topBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            textView.topAnchor.constraint(equalTo: topBackground.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingConstraint!,
        ])
        super.updateConstraints()
    }
    
    func setContents(author: String?, post: String?, indent: Int) {
        authorLabel.text = author
        textView.text = post
        self.indentIndex = indent
    }
    
    private func indentForIndex() -> CGFloat{
        return CGFloat(Double(indentIndex) * 20)
        
    }
    
}
