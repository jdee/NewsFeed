//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import XCTest

class NewsFeedTests: XCTestCase {
    var newsFeed: NewsFeed!
    
    override func setUp() {
        super.setUp()
        newsFeed = NewsFeed()
    }

    func testInitialState() {
        XCTAssertEqual(newsFeed.status, .notLoaded)
    }

    func testFileLoad() {
        let url = Bundle.main.url(forResource: "test", withExtension: "json")

        newsFeed.load(urlString: url?.absoluteString ?? "")

        // Rather than complicate this test with a delegate.
        usleep(100000)

        XCTAssertEqual(newsFeed.status, .loaded)

        // Actual parsing of the file is tested in the NewsFeedParserTests.
    }

    func testLoadFailure() {
        let url = URL(string: "file:///bad/file/path")
        XCTAssertNotNil(url)

        newsFeed.load(urlString: url?.absoluteString ?? "")

        // Rather than complicate this test with a delegate.
        usleep(100000)
        
        XCTAssertEqual(newsFeed.status, .error)
    }

    func testInvalidJson() {
        let url = Bundle.main.url(forResource: "bad-test", withExtension: "json")
        
        newsFeed.load(urlString: url?.absoluteString ?? "")
        
        // Rather than complicate this test with a delegate.
        usleep(100000)
        
        XCTAssertEqual(newsFeed.status, .error)
    }
}
