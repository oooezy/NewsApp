//
//  BookmarkTableViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/17.
//

import UIKit

protocol bookmarkVCDelegate: AnyObject {
    func removeBookmark(_ cell: BookmarkTableViewCell)
}

class BookmarkTableViewCell: UITableViewCell {
    
    weak var delegate: bookmarkVCDelegate?

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeButton.setTitle("", for: .normal)
        
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        thumbImageView.layer.cornerRadius = 15
        
        textView.layer.masksToBounds = true
        textView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textView.layer.cornerRadius = 15
        
    }
    
    @IBAction func removeBookmark(_ sender: UIButton) {
        bookmarkCount -= 1
        delegate?.removeBookmark(self)
    }
}
