//
//  ViewController.swift
//  Reddit Listings
//
//  Created by Gabriel Spound on 8/18/20.
//  Copyright © 2020 Gabriel Spound. All rights reserved.
//

import UIKit

class ListingVC: UITableViewController {
    
    final let cellReuseID = "ListingCell"
    
    var viewModels = [ListingModel]()
    
    var selectedSubReddit = SubReddits.sourdough
    
    var selectedListingType = ListingTypes.hot
    
    var paginationID: String?
    
    var didFinishFetching = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViews()
    }
    
    private func setupViews() {
        title = selectedSubReddit.asString()
        tableView.register(ListingCell.self, forCellReuseIdentifier: cellReuseID)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! ListingCell
        
        guard viewModels.count - 1 >= indexPath.row else {return cell}
        let cellModel = viewModels[indexPath.row]
        
        cell.setContents(image: cellModel.image, title: cellModel.title)
        
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModels[indexPath.row]
        
        let destinationVC = ListingPage(id: vm.id, title: vm.title, thumbnailImage: vm.image ?? UIImage(named: "Reddit_Logo")!, subReddit: selectedSubReddit)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func loadData() {
        Session.session.getListingsFor(sub: selectedSubReddit, listing: selectedListingType, paginationIndex: paginationID) {[weak self] (responseModel) in
            guard let responseModel = responseModel, self != nil else {return}
            
            let initialOffset = self!.viewModels.count // Because we use a posts index relative to the viewModel array to load in images asynchronously, we need this value to add to the index of the responseModels array (line 83)
            
            for (index, p) in responseModel.listing.posts.enumerated() {
                guard let title = p.data.title, let id = p.data.articleID else { continue }
                
                let _listingModel = ListingModel(title: title,
                                                 image: nil, //Image is nil because it will be loaded in later
                                                 id: id)
                
                if (p.data.thumbnail != "self") {
                    self!.loadImageFor(url: p.data.thumbnail ?? "", indexOfCell: index + initialOffset) // Load Image
                }
                self!.viewModels.append(_listingModel)
            }
            self!.paginationID = responseModel.listing.after // Used for later calls of this function, to get the listings after this ID
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
            self?.didFinishFetching = true
        }
    }
    
    func loadImageFor(url: String, indexOfCell: Int) {
        Session.session.downloadDataForImage(from: URL(string: url)!) { [weak self, indexOfCell] (imageData) in
            guard self != nil else { return }
            let img = UIImage(data: imageData)
            self!.viewModels[indexOfCell].image = img
            DispatchQueue.main.async {
                if let cell = self!.tableView.cellForRow(at: IndexPath(row: indexOfCell, section: 0)) as? ListingCell {
                    cell.setContents(image: img, title: nil)
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && viewModels.count > 0 {
            if (didFinishFetching && (paginationID != nil)) {
                didFinishFetching = false
                loadData()
            }
        }
    }

}

struct ListingModel {
    let title: String
    var image: UIImage?
    let id: String
}

