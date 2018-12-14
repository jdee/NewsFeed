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

    @IBOutlet var webView: WKWebView!

    var article: Article! {
        didSet {
            title = article.sourceName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let url = URL(string: article.url ?? "") else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load article \(article.url!): \(error.localizedDescription)")
    }
}
