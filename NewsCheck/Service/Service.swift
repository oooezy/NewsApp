//
//  APICaller.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/04/30.
//

import Foundation

final class Service {
    static let shared = Service()
    
    struct Constants {
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=980a7a575beb40e68cadd8222e19ee58"
        static let searchURL = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=980a7a575beb40e68cadd8222e19ee58&q="
        static let categoryURL = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=980a7a575beb40e68cadd8222e19ee58&category="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result <[Article], Error>) -> Void) {
        let urlString = Constants.topHeadlinesURL
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: encodedString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func getTopStoriesWithCategory (with category: String, completion: @escaping (Result <[Article], Error>) -> Void) {
        guard !category.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.categoryURL + category
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: encodedString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result <[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchURL + query
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let url = URL(string: encodedString)!
                
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
