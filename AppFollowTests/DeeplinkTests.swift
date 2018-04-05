//
//  AppFollowTests.swift
//  AppFollowTests
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import XCTest
@testable import AppFollow

class DeeplinkTests: XCTestCase {

    
    func testExtract() {
        self.validate(
            url: "https://watch.appfollow.io/apps/powerbi/reviews/31613/",
            appId: "31613", reviewId: "", collection: "powerbi", isValid: true)
        self.validate(
            url: "https://watch.appfollow.io/apps/apps/app/33785",
            appId: "33785", reviewId: "", collection: "apps", isValid: true)
        self.validate(
            url: "https://watch.appfollow.io/apps/apps/reviews/33785",
            appId: "33785", reviewId: "", collection: "apps", isValid: true)
        self.validate(
            url: "https://watch.appfollow.io/apps",
            appId: "", reviewId: "", collection: "", isValid: false)
        self.validate(
            url: "https://appfollow.io/app/50742/review/36729462?s=vip",
            appId: "50742", reviewId: "36729462", collection: "", isValid: true)
    }
    
    func validate(url: String, appId: String, reviewId: String, collection: String, isValid: Bool) {
        let deeplink = Deeplink(url: URL(string: url)!)
        
        XCTAssertEqual(deeplink.isValid, isValid)
        XCTAssertEqual(deeplink.appId.value, appId)
        XCTAssertEqual(deeplink.reviewId.value, reviewId)
        XCTAssertEqual(deeplink.collection, collection)
    }
}
