//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by 이은지 on 2022/04/30.
//

import UIKit
import SafariServices

protocol CVCellDelegate {
    func selectedCVCell(_ index: Int)
}

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data? = nil
    let author: String
    let publishedAt: String
    let url: String
    
    init(title: String, description: String, imageURL: URL?, author: String, publishedAt: String, url: String) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.author = author
        self.publishedAt = publishedAt
        self.url = url
    }
}

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModels = [NewsTableViewCellViewModel]()
    var delegate: CVCellDelegate?
    
    func configureCell(with viewModels: [NewsTableViewCellViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionViews()
    }

    func setUpCollectionViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Extension
extension NewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.configureCell(with: viewModels[indexPath.row])
        cell.backgroundColor = UIColor.lightBGColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.selectedCVCell(indexPath.item)
        }
    }
}

extension NewsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 1.8
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}

 
