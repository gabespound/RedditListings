//
//  ListingPage.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/18/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import UIKit

class ListingPage: UIViewController {
    
    lazy var thumbnailView: UIImageView! = {
        let _thumbnailView = UIImageView(image: UIImage(named: "Reddit_Logo"))
        _thumbnailView.alpha = 0.4
        _thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        _thumbnailView.contentMode = .scaleAspectFit
        
        return _thumbnailView
    }()
    
    lazy var titleLabel: UILabel! = {
        let _titleLabel = UILabel(frame: .zero)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        _titleLabel.numberOfLines = 2
        _titleLabel.textColor = .black
        _titleLabel.backgroundColor = .clear
        
        return _titleLabel
    }()
    
    lazy var postTextView: UITextView! = {
        let _postTextView = UITextView(frame: .zero)
        _postTextView.translatesAutoresizingMaskIntoConstraints = false
        _postTextView.isScrollEnabled = true
        _postTextView.backgroundColor = .white
        _postTextView.isEditable = false
        _postTextView.backgroundColor = .clear
        _postTextView.font = UIFont.systemFont(ofSize: 16)
        
        return _postTextView
    }()
    
    lazy var commentTableView: UITableView! = {
        let _commentTableView = UITableView(frame: .zero)
        _commentTableView.delegate = self
        _commentTableView.dataSource = self
        _commentTableView.translatesAutoresizingMaskIntoConstraints = false
        _commentTableView.register(CommentCell.self, forCellReuseIdentifier: reuseID)
        _commentTableView.separatorStyle = .none
        _commentTableView.allowsSelection = false
        
        return _commentTableView
    }()
    
    final let reuseID = "CommentCell"
    
    var viewModels = [commentModel]()
    
    var listingID: String
    var chosenSubReddit: SubReddits
    
    var paginationID: String?
    var loadedMD = false
    var didFinishFetching = true

    init(id: String, title: String, thumbnailImage: UIImage, subReddit: SubReddits) {
        listingID = id
        chosenSubReddit = subReddit
        super.init(nibName: nil, bundle: nil)
        thumbnailView.image = thumbnailImage
        titleLabel.text = title
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setupConstraints() {
        view.addSubview(thumbnailView)
        view.addSubview(titleLabel)
        view.addSubview(postTextView)
        view.addSubview(commentTableView)
        
        NSLayoutConstraint.activate([
            thumbnailView.widthAnchor.constraint(equalTo: view.widthAnchor),
            thumbnailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            thumbnailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            
            postTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12),
            postTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            postTextView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor),
            postTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            commentTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            commentTableView.topAnchor.constraint(equalTo: postTextView.bottomAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            commentTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        view.sendSubviewToBack(thumbnailView)
    }
    
    func loadData() {
        Session.session.getCommentsFor(sub: chosenSubReddit, articleID: listingID, paginationIndex: paginationID) {
            [weak self] (responseModels) in
            guard var models = responseModels, self != nil else {return}
            guard models.count > 0 else {return}
            guard models[0].listing.posts.count > 0 else {return}
            if (models[0].listing.posts[0].kind == "t3") { //Check if the first post in the array is the OP, and if it is, remove it.
                if (!self!.loadedMD) {
                    DispatchQueue.main.async {
                        self?.postTextView.text = models[0].listing.posts[0].data.selfText ?? ""
                    }
                    self!.loadedMD = true
                }
                models.removeFirst()
            }
            
            guard !models.isEmpty else {return}
            for p in models[0].listing.posts {
                let model = commentModel(user: p.data.author ?? "", text: p.data.commentBody ?? "", layer: 0)
                self!.viewModels.append(model)
                if p.data.replies != nil {
                    self!.recurseivelyLoadComments(layer: 1, rootModel: p.data.replies!) //Comments can have many layers of replies, so I load them recursively
                }
            }
            self?.paginationID = models[0].listing.after
            DispatchQueue.main.async {
                self!.commentTableView.reloadData()
            }
            self!.didFinishFetching = true
        }
    }
    
    func recurseivelyLoadComments(layer: Int, rootModel: ListingResponseModel) {
        for p in rootModel.listing.posts {
            let model = commentModel(user: p.data.author ?? "", text: p.data.commentBody ?? "", layer: layer)
            viewModels.append(model)
            if (p.data.replies != nil) {
                recurseivelyLoadComments(layer: layer + 1, rootModel: p.data.replies!)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && viewModels.count > 0 {
            if (didFinishFetching && (paginationID != nil)) { // Load new Comments if scrollView has reached the bottom, and the vc is not currently fetching new comments
                didFinishFetching = false
                loadData()
            }
        }
    }
    

}

extension ListingPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! CommentCell
        guard viewModels.count - 1 >= indexPath.row else {return cell}
        let cellModel = viewModels[indexPath.row]
        
        cell.setContents(author: cellModel.user, post: cellModel.text, indent: cellModel.layer)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

struct commentModel {
    let user: String
    let text: String
    let layer: Int
}

