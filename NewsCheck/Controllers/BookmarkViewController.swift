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
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var defaultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        
        if let url = URL(string: bookmarkArr[indexPath.row][3]) {
            if let data = try? Data(contentsOf: url) {
                cell.thumbImageView.image = UIImage(data: data)
            } else {
                cell.thumbImageView.image = UIImage(named: "defaultThumb")
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]

        guard let url = URL(string: article.url ?? "") else { return }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
