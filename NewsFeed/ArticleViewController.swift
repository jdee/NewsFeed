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
            title = article.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let url = URL(string: article.url ?? "") else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }
}
