//
//  NewsFeedParser.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit

enum ParseError: Error {
    case noStatusField
    case noArticlesField
    case generic(message: String)
}

struct NewsFeedParser {
    static func parse(response: Dictionary<String, Any>) throws -> [Article] {
        guard let status = response["status"] as? String else {
            throw ParseError.noStatusField
        }

        guard let articles = response["articles"] as? [Dictionary<String, Any>] else {
            throw ParseError.noArticlesField
        }
        
        if status == "ok" {
            return process(response: articles)
        }
        else {
            throw ParseError.generic(message: status)
        }
    }

    // Populate self.articles from result
    private static func process(response: [Dictionary<String, Any>]) -> [Article] {
        var articles = [Article]()

        for var article in response {
            guard let title = article["title"] as? String,
                let url = article["url"] as? String,
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
            newsArticle.author = article["author"] as? String
            
            if let pubTime = article["publishedAt"] as? String {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                newsArticle.publicationTime = formatter.date(from: pubTime)
            }
            
            articles.append(newsArticle)
        }
        
        return articles
    }
}
