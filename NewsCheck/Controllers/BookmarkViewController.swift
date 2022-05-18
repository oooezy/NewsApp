//
//  BookmarkViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/17.
//

import UIKit
import SafariServices

class BookmarkViewController: UIViewController {
    
    lazy var bookmarkArr = [[String]]()
    lazy var searchVC = SearchViewController()

    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var bookmarkTitle: String? = ""
    var author: String? = ""
    var date: String? = ""
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBGColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
//        print("받음: \(bookmarkArr)")
//        if !bookmarkArr.isEmpty {
            setUpTableView()
//            bookmarkImageView.image = nil
//            textLabel.removeFromSuperview()

//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(row: bookmarkArr.count - 1, section: 0)], with: .automatic)
//            tableView.endUpdates()
//        }

    }
    
    func setUpTableView() {
        tableView.backgroundColor = .red
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
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

        cell.titleLabel.text = bookmarkTitle
        cell.authorLabel.text = author
        cell.dateLabel.text = date
        
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let article = articles[indexPath.row]
//
//        guard let url = URL(string: article.url ?? "") else { return }
//
//        let vc = SFSafariViewController(url: url)
//        present(vc, animated: true)
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
