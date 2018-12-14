//
//  ArticleViewController.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {
    static let identifier = "Article"

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var webView: WKWebView!

    var article: Article! {
        didSet {
            title = article.sourceName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = article.title
        if let author = article.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        }
        else {
            authorLabel.isHidden = true
        }

        if let date = article.publicationTime {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium

            dateLabel.text = formatter.string(from: date)
            dateLabel.isHidden = false
        }
        else {
            dateLabel.isHidden = true
        }

        view.setNeedsLayout()

        webView.navigationDelegate = self
        guard let url = URL(string: article.url ?? "") else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load article \(article.url!): \(error.localizedDescription)")
    }
}
