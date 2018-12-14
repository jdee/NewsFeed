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
    var author: String?
    var url: String?
    var sourceName: String?
    var publicationTime: Date?
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

    func load(urlString: String = NewsFeed.url) {
        guard status != .loading else { return } // let any load in progress complete. silently ignore this call.
        status = .loading
        articles = []

        guard let url = URL(string: urlString) else {
            notifyDelegate(error: "Malformed URL")
            return
        }

        /*
         * This is a simple way to load data from a URL in this case: Dispatch the synchronous
         * Data(contentsOf: url) to a background thread and then dispatch the results back to
         * the main thread.
         */
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else {
                    self.notifyDelegate(error: "Failed to deserialize response")
                    return
                }

                self.articles = try NewsFeedParser.parse(response: response)
                self.notifyDelegate(error: nil)
            }
            catch {
                /*
                 * TODO: Improve handling of different error cases. The details are not
                 * interesting to the user, but specific error messages can only be
                 * reported here.
                 */
                self.notifyDelegate(error: "Failed to load \(url)")
            }
        }
    }

    private func notifyDelegate(error: String?) {
        status = error == nil ? .loaded : .error
        DispatchQueue.main.async {
            self.delegate?.loadComplete(newsFeed: self, error: error)
        }
    }
}
