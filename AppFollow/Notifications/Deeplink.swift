//
//  Deeplink.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 05/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

// https://watch.appfollow.io/apps/powerbi/reviews/31613/
// https://watch.appfollow.io/apps/powerbi/reviews/31615/?review_id=577705
// https://watch.appfollow.io/apps/apps/app/33785
// https://watch.appfollow.io/apps/apps/reviews/33785
// https://watch.appfollow.io/apps
// https://appfollow.io/app/50742/review/36729462?s=vip
struct Deeplink {
    let url: URL
    
    let appId: AppId
    let reviewId: ReviewId
    let collection: String
    
    var isValid: Bool {
        get { return
            !self.collection.isEmpty ||
            !self.appId.isEmpty ||
            !(self.reviewId.isEmpty && self.appId.isEmpty)
        }
    }
    
    init(url: URL) {
        self.url = url
        
        var components = url.pathComponents
        components.removeFirst() // Without "/"
        self.appId = Deeplink.extractAppId(components)
        self.reviewId = Deeplink.extractReviewId(components, url.queryComponents)
        self.collection = Deeplink.extractCollection(components)
    }
    
    private static func extractAppId(_ path: [String]) -> AppId {
        if path.count > 1 {
            if path[0] == "app" {
                return AppId(value: path[1])
            } else if path[0] == "apps" {
                if path.count > 3 {
                    if path[2] == "app" || path[2] == "reviews" {
                        return AppId(value: path[3])
                    }
                }
            }
        }
        return AppId.empty
    }
    
    private static func extractCollection(_ path: [String]) -> String {
        if path.count > 1 {
            if path[0] == "apps" {
                return path[1]
            }
        }
        return ""
    }
    
    private static func extractReviewId(_ path: [String], _ query: [String: String]) -> ReviewId {
        if path.count > 3 {
            if path[0] == "app" && path[2] == "review" {
                return ReviewId(value: path[3])
            }
        }
        if let reviewId = query["review_id"] {
            return ReviewId(value: reviewId)
        }
        return ReviewId.empty
    }
}
