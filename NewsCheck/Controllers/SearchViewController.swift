//
//  ViewController.swift
//  NewsApp
//
//  Created by 이은지 on 2022/05/02.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    var category: [String:String] = [
        "비즈니스" : "business",
        "엔터테인먼트" : "entertainment",
        "건강" : "health",
        "과학" : "science",
        "일반" : "general",
        "스포츠" : "sports",
        "기술" : "technology",
    ]

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article]()
    var viewModels = [NewsTableViewCellViewModel]()
    
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBGColor
        
        setUpSearchBar()
        setUpTableView()
        fetch(with: "business")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
   }
    
    // MARK: - Private
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "Search_ic"), for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.updateHeight(height: 48)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(hex: 0xEEEEEE)
            textfield.textColor = .fontColorGray
            textfield.font = UIFont.NanumSquare(type: .Regular, size: 14)
            textfield.layer.cornerRadius = 15
        }
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
    }
    
    private func fetch(with category: String) {
        Service.shared.getTopStoriesWithCategory (with: category) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap( {
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        description: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        author: $0.author ?? "",
                        publishedAt: $0.publishedAt,
                        url: $0.url ?? ""
                    )
                })

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: -IBAction
    @IBAction func buttonPressed(_ sender: UIButton) {
        categoryButtons.forEach {
            $0.isSelected = false
            $0.setTitleColor(.fontColorGray, for: .normal)
            $0.titleLabel?.font = UIFont.NanumSquare(type: .Regular, size: 16)
        }
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.NanumSquare(type: .ExtraBold, size: 16)
        sender.tintColor = .clear
        
        guard let category = category[sender.currentTitle!], !category.isEmpty else {
            return
        }
        
        fetch(with: category)
    }
}

// MARK: - Extension
// SearchBar
extension SearchViewController: UISearchBarDelegate {
    override func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        Service.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap( {
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        description: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        author: $0.author ?? "",
                        publishedAt: $0.publishedAt,
                        url: $0.url ?? ""
                    )
                })

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}

// TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as!
                ListTableViewCell

        cell.delegate = self
        cell.configureCell(with: viewModels[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else { return }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension SearchViewController: ListTVCellDelegate {
    func addBookmarkList(_ cell: ListTableViewCell, index: Int) {
        let title = cell.titleLabel.text!
        let author = cell.authorLabel.text ?? ""
        let date = cell.dateLabel.text ?? ""
        let imgURL = cell.imgURL ?? ""
        let url = cell.url
        let description = cell.descriptionLabel.text ?? "No description"

        bookmarkArr.append(contentsOf: [[title, author, date, imgURL, url, description]])
        UserDefaults.standard.set(bookmarkArr, forKey: "bookmarkList")
    }
    
    func removeBookmarkList(_ cell: ListTableViewCell, index: Int) {
        let title = cell.titleLabel.text!
        
        for arr in bookmarkArr {
            if arr[0] == title {
                let idx = bookmarkArr.firstIndex(of: arr)
                bookmarkArr.remove(at: idx!)
                
                UserDefaults.standard.set(bookmarkArr, forKey: "bookmarkList")
            }
        }
    }
}
