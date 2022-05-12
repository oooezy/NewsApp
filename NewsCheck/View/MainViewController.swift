//
//  MainViewController.swift
//  NewsApp
//
//  Created by 이은지 on 2022/04/30.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {

    // MARK: - VIEW
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func nextPage(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    var articles = [Article]()
    var viewModels = [NewsTableViewCellViewModel]()
    var sliderModels = [SliderCollectionViewCellViewModel]()
    
    // MARK: - CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBGColor
        
        let image = UIImage(named: "titleLogo")
        navigationItem.titleView = UIImageView(image: image)
        
        setUpCollectionView()
        setUpTableView()
        setUpPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTopStories()
        fetchStories()
    }
    
    // MARK: - Private
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nibName = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.cornerRadius = 30
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let nibName = UINib(nibName: "SlideCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "SlideCollectionViewCell")
    }
    
    private func fetchTopStories() {
        Repository.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.sliderModels = articles[0...5].compactMap ({
                    SliderCollectionViewCellViewModel(
                        title: $0.title,
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchStories() {
        Repository.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles[6...].compactMap ({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        description: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        author: $0.author ?? "",
                        publishedAt: $0.publishedAt
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
    
    private func setUpPageControl() {
        pageControl.numberOfPages = 6
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let OFFSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(OFFSet + horizontalCenter) / Int(width)
    }
}

// MARK: - Extension
// CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
        cell.configure(with: sliderModels[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height

        return CGSize(width: width, height: height)
    }
}

// TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.backgroundColor = .lightBGColor
        cell.configureCell(with: viewModels)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

extension MainViewController: CVCellDelegate {
    func selectedCVCell(_ index: Int) {
        let article = articles[index + 6]

        guard let url = URL(string: article.url ?? "") else { return }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
