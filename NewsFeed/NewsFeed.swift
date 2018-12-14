//
//  NewsFeed.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit

@objc protocol NewsFeedDelegate {
    func loadComplete(newsFeed: NewsFeed, error: String?)
}

struct Article {
    var title: String?
    var url: String?
    var sourceName: String?
}

enum NewsFeedStatus {
    case notLoaded
    case loading
    case loaded
    case error
}

class NewsFeed: NSObject {
    static let apiKey = "a2a7cc3f08ce4a3889d14c323f1c70c9"
    static let url = "https://newsapi.org/v2/top-headlines?country=US&apiKey=\(apiKey)"

    weak var delegate: NewsFeedDelegate?
    private (set) var articles = [Article]()
    private (set) var status = NewsFeedStatus.notLoaded

    func load() {
        guard status != .loading else { return } // let any load in progress complete. silently ignore this call.
        status = .loading
        articles = []

        guard let url = URL(string: NewsFeed.url) else {
            notifyDelegate(error: "Malformed URL")
            return
        }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else {
                    self.notifyDelegate(error: "Failed to deserialize response")
                    return
                }

                guard let status = response["status"] as? String else {
                    self.notifyDelegate(error: "No status field in response")
                    return
                }

                guard let articles = response["articles"] as? [Dictionary<String, Any>] else {
                    self.notifyDelegate(error: "No articles field in response")
                    return
                }

                if status == "ok" {
                    let result = self.process(response: articles)
                    self.notifyDelegate(error: result)
                }
                else {
                    self.notifyDelegate(error: status)
                }
            }
            catch {
                self.notifyDelegate(error: "Failed to load \(url)")
            }
        }
    }

    // Populate self.articles from result
    private func process(response: [Dictionary<String, Any>]) -> String? {
        for var article in response {
            guard let title = article["title"] as? String, let url = article["url"] as? String,
                let source = article["source"] as? Dictionary<String, Any>,
                let sourceName = source["name"] as? String else {
                // Or could return this as an error to fail all processing
                print("Ignoring incomplete article")
                continue
            }

            var newsArticle = Article()
            newsArticle.title = title
            newsArticle.url = url
            newsArticle.sourceName = sourceName

            articles.append(newsArticle)
        }

        return nil
    }

    private func notifyDelegate(error: String?) {
        status = error == nil ? .loaded : .error
        DispatchQueue.main.async {
            self.delegate?.loadComplete(newsFeed: self, error: error)
        }
    }
}
