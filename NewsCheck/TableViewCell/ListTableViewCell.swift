//
//  ListTableViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/02.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModels = [NewsTableViewCellViewModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    func configureCell(with viewModel: NewsTableViewCellViewModel) {
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.clipsToBounds = true
        
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString

        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let date = formatter.date(from: viewModel.publishedAt)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        dateLabel.text = dateFormatter.string(from: date)
        
        // Image
        if let data = viewModel.imageData {
            thumbImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.thumbImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            thumbImageView.image = UIImage(named: "defaultThumb")
        }
    }
    
}
