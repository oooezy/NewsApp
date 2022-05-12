//
//  headlineTableViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/04/13.
//

import UIKit

class HeadlineTableViewCellViewModel {
    let category: String
    let title: String
    let imageURL: URL?
    var imageData: Data? = nil
    let name: String
    
    init(
        category: String,
        title: String,
        imageURL: URL?,
        name: String
    ) {
        self.title = title
        self.imageURL = imageURL
        self.name = name
    }
}

class HeadlineTableViewCell: UITableViewCell {
    static let identifier = "HeadlineTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        
        label.linespace(spacing: 24)
        label.numberOfLines = 0
        label.font = UIFont.NanumSquare(type: .Bold, size: 16)
        
        return label
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .fontColorGray
        label.font = UIFont.NanumSquare(type: .Regular, size: 12)

        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = UIColor(hex: 0xEBEBEB)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        
        newsImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: 86,
            height: 88
        )
        
        newsTitleLabel.frame = CGRect(
            x: 100,
            y: 0,
            width: contentView.frame.size.width - 100,
            height: 50
        )

        name.frame = CGRect(
            x: 100,
            y: 60,
            width: contentView.frame.size.width - 170,
            height: 20
        )
        
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLabel.text = nil
        name.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        name.text = viewModel.name
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            newsImageView.image = UIImage(named: "logo_ic.svg")
        }
    }
}
