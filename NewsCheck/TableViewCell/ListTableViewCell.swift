//
//  ListTableViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/02.
//

import UIKit

protocol ListTVCellDelegate: AnyObject {
    func addBookmarkList(_ cell: ListTableViewCell, index: Int)
    func removeBookmarkList(_ cell: ListTableViewCell, index: Int)
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    var viewModels = [NewsTableViewCellViewModel]()
    weak var delegate: ListTVCellDelegate?
    
    var isChecked = false
    var bookmarkCount: Int = 0
    var imgURL: String? = ""
    var url: String = ""
    
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
        
        let text = viewModel.title
        titleLabel.text = text.split(separator: "-").dropLast(1).joined()
        authorLabel.text = viewModel.author
        descriptionLabel.text = viewModel.description
        
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString
        
        let descriptionString = NSMutableAttributedString(string: descriptionLabel.text!)
        descriptionString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, descriptionString.length))
        descriptionLabel.attributedText = descriptionString
        
        // date formatter
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let date = formatter.date(from: viewModel.publishedAt)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        dateLabel.text = dateFormatter.string(from: date)
        
        // url
        url = viewModel.url
        
        // Image
        if let data = viewModel.imageData {
            thumbImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            imgURL = String(describing: url)
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
    
    @IBAction func didTapBookmark(_ sender: UIButton) {
        isChecked = !isChecked
        
        if isChecked {
            bookmarkCount += 1
            bookmarkButton.setImage(UIImage(named: "bookmark_On"), for: .normal)
            delegate?.addBookmarkList(self, index: bookmarkCount - 1)

        } else {
            bookmarkCount -= 1
            bookmarkButton.setImage(UIImage(named: "bookmark_Off"), for: .normal)
            delegate?.removeBookmarkList(self, index: bookmarkCount)
        }
    }

}
