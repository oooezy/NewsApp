//
//  SlideCollectionViewCell.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/02.
//

import UIKit

class SliderCollectionViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data? = nil

    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

class SliderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with sliderModels: SliderCollectionViewCellViewModel) {
        let text = sliderModels.title
        titleLabel.text = text.split(separator: "-").dropLast(1).joined()
        
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString

        if let data = sliderModels.imageData {
            imageView.image = UIImage(data: data)
        } else if let url = sliderModels.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                sliderModels.imageData = data
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            imageView.image = UIImage(named: "default.svg")
        }
    }
}
