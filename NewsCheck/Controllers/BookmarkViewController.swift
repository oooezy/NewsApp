//
//  BookmarkViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/17.
//

import UIKit
import SafariServices

var bookmarkArr = [[String]]()

class BookmarkViewController: UIViewController {

    lazy var searchVC = SearchViewController()
    
    var articles = [Article]()
    var viewModels = [NewsTableViewCellViewModel]()
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var defaultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bookmarkArr = UserDefaults.standard.array(forKey: "bookmarkList") as? [[String]] ?? [[]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bookmarkArr.isEmpty {
            self.view.bringSubviewToFront(defaultView)
        } else {
            self.view.bringSubviewToFront(tableView)
            self.view.sendSubviewToBack(defaultView)
            tableView.reloadData()
        }
    }

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "BookmarkTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BookmarkTableViewCell")
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as!
        BookmarkTableViewCell

        cell.titleLabel.text = bookmarkArr[indexPath.row][0]
        cell.authorLabel.text = bookmarkArr[indexPath.row][1]
        cell.dateLabel.text = bookmarkArr[indexPath.row][2]
        cell.descriptionLabel.text = bookmarkArr[indexPath.row][5]
        
        let attrString = NSMutableAttributedString(string: cell.titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        cell.titleLabel.attributedText = attrString
        
        let descriptionString = NSMutableAttributedString(string: cell.descriptionLabel.text!)
        descriptionString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, descriptionString.length))
        cell.descriptionLabel.attributedText = descriptionString
        
        if let url = URL(string: bookmarkArr[indexPath.row][3]) {
            if let data = try? Data(contentsOf: url) {
                cell.thumbImageView.image = UIImage(data: data)
            } else {
                cell.thumbImageView.image = UIImage(named: "defaultThumb")
            }
        }

        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = bookmarkArr[indexPath.row][4]

        guard let url = URL(string: link) else { return }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}


extension BookmarkViewController: bookmarkVCDelegate {
    func removeBookmark(_ cell: BookmarkTableViewCell) {
        
        let title = cell.titleLabel.text!
        print(title)
        
        for arr in bookmarkArr {
            if arr[0] == title {
                let idx = bookmarkArr.firstIndex(of: arr)
                bookmarkArr.remove(at: idx!)
                tableView.reloadData()
            }
        }
        
        print(bookmarkArr)
        
        if bookmarkArr.isEmpty {
            self.view.bringSubviewToFront(defaultView)
        } else {
            self.view.bringSubviewToFront(tableView)
            self.view.sendSubviewToBack(defaultView)
            tableView.reloadData()
        }
        UserDefaults.standard.set(bookmarkArr, forKey: "bookmarkList")
    }
}
