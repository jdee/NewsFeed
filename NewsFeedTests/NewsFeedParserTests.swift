//
//  NewsFeedParserTests.swift
//  NewsFeedTests
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import XCTest
import NewsFeed

class NewsFeedParserTests: XCTestCase {

    func testNoStatusField() {
        let response = [
            "articles": [
                [
                    "title": "Title",
                    "source": [
                        "name": "CNN"
                    ]
                ]
            ]
        ]
        
        do {
            let _ = try NewsFeedParser.parse(response: response)
            XCTFail("Exception not thrown")
        }
        catch ParseError.noStatusField {
            
        }
        catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testBadStatus() {
        let response: [String: Any] = [
            "status": "an error"
        ]

        do {
            let _ = try NewsFeedParser.parse(response: response)
            XCTFail("Exception not thrown")
        }
        catch ParseError.generic(let message) {
            XCTAssertEqual(message, "an error")
        }
        catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testNoArticlesField() {
        let response = [
            "status": "ok"
        ]

        do {
            let _ = try NewsFeedParser.parse(response: response)
            XCTFail("Exception not thrown")
        }
        catch ParseError.noArticlesField {

        }
        catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testIncompleteArticles() {
        let response: [String: Any] = [
            "status": "ok",
            "articles": [
                [
                    "title": "Title 1",
                    "author": "Author 1",
                    "url": "https://www.example1.com"
                    // no source
                ],
                [
                    "author": "Author 2",
                    "url": "https://www.example2.com",
                    "source": [
                        "name": "Example 2"
                    ]
                    // no title
                ],
                [
                    "title": "Title 3",
                    "author": "Author 3",
                    "source": [
                        "name": "Example 3"
                    ]
                    // no url
               ]
            ]
        ]

        do {
            let articles = try NewsFeedParser.parse(response: response)
            XCTAssertEqual(0, articles.count)
        }
        catch {
            XCTFail("Exception thrown")
        }
    }

    func testCompleteResults() {
        let response: [String: Any] = [
            "status": "ok",
            "articles": [
                [
                    "title": "Title",
                    "author": "Author",
                    "url": "https://www.example.com",
                    "publishedAt": "2018-12-14T00:00:00Z",
                    "source": [
                        "name": "Example"
                    ]
                ]
            ]
        ]

        do {
            let articles = try NewsFeedParser.parse(response: response)
            XCTAssertEqual(1, articles.count)
            let article = articles[0]
            XCTAssertEqual("Title", article.title)
            XCTAssertEqual("Author", article.author)
            XCTAssertEqual("https://www.example.com", article.url)
            XCTAssertEqual("Example", article.sourceName)
            XCTAssertNotNil(article.publicationTime)
        }
        catch {
            XCTFail("Exception thrown")
        }
    }
}
