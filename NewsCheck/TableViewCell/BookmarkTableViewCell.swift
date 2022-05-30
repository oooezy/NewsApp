//
//  BookmarkTableViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/17.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
        thumbImageView.layer.cornerRadius = 15
        
    }
    
    @IBAction func removeBookmark(_ sender: UIButton) {
//        bookmarkCount -= 1
    }
}
