//
//  ViewController.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsFeedDelegate {
    static let identifier = "NewsFeed"

    @IBOutlet var headlineTableView: UITableView!
    let newsFeed = NewsFeed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsFeed.delegate = self
        load()
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.status == .loaded ? newsFeed.articles.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: HeadlineTableViewCell.identifier) ?? HeadlineTableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < newsFeed.articles.count else {
            return
        }

        guard let headlineCell = cell as? HeadlineTableViewCell else {
            return
        }

        headlineCell.headlineLabel.text = newsFeed.articles[indexPath.row].title
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < newsFeed.articles.count else {
            return tableView.rowHeight
        }
        guard let title = newsFeed.articles[indexPath.row].title else {
            return tableView.rowHeight
        }

        let font = UIFont.systemFont(ofSize: 17)
        let constrainedSize = CGSize(width: headlineTableView.bounds.width - 20, height: 200)
        let attributed = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font])
        let size = attributed.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, context: nil)
        return size.height + 20
    }

    // MARK: - NewsFeedDelegate

    func loadComplete(newsFeed: NewsFeed, error: String?) {
        guard error == nil else {
            print("Error loading feed: \(error!)")
            return
        }

        headlineTableView.reloadData()
    }

    private func load() {
        // For now, don't reload once loaded.
        guard newsFeed.status != .loaded else { return }
        newsFeed.load()
    }
}

