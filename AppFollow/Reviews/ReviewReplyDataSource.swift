//
//  ReviewReplyDataSource.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 02/04/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import UIKit

private protocol ReplyItem {
    
}

private struct Feedback: ReplyItem {
    let review: Review
}

private struct Reply: ReplyItem {
    let answer: String
    let date: String
}

class ReviewReplyDataSource: NSObject, UITableViewDataSource {
    
    let reviewId: ReviewId
    let app: App
    let auth: Auth
    
    private var items: [ReplyItem] = []
    private var review = Review.empty
    
    init(reviewId: ReviewId, app: App, auth: Auth) {
        self.reviewId = reviewId
        self.app = app
        self.auth = auth
    }
    
    func reload(completion: @escaping () -> Void) {
        let parameters = ReviewsEndpoint.parameters(extId: self.app.extId, reviewId: self.reviewId, auth: self.auth)
        ApiRequest(url: ReviewsEndpoint.url, parameters: parameters).send {
            (response: AppReviewsResponse?) in
            if let review = response?.reviews.list.first {
                self.review = review
                self.items = self.createItems(review: review)
            }
            completion()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        
        if let feedback = item as? Feedback {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.bind(review: feedback.review, app: self.app)
            return cell
        } else if let reply = item as? Reply {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            cell.bind(answer: reply.answer, date: reply.date)
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func createItems(review: Review) -> [ReplyItem]{
        var items = [ReplyItem]()
        if !review.history.isEmpty {
            for review in review.history {
                items.append(Feedback(review: review))
                if review.answered {
                    items.append(Reply(answer: review.answer, date: review.date))
                }
            }
        }
        items.append(Feedback(review: review))
        if review.answered {
            items.append(Reply(answer: review.answer, date: review.date))
        }
        return items
    }
}
