//
//  ViewController.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let identifier = "NewsFeed"
    
    @IBOutlet var headlineTableView: UITableView!

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: HeadlineTableViewCell.identifier) ?? HeadlineTableViewCell()
    }
}

