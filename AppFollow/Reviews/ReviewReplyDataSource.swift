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
    let answer: ReviewAnswer
}

class ReviewReplyDataSource: NSObject, UITableViewDataSource {
    
    let reviewId: ReviewId
    let app: App
    let auth: AuthProvider
    
    private var items: [ReplyItem] = []
    private var review = Review.empty
    
    init(reviewId: ReviewId, app: App, auth: AuthProvider) {
        self.reviewId = reviewId
        self.app = app
        self.auth = auth
    }
    
    func reload(completion: @escaping (_ review: Review) -> Void) {
        ApiRequest(route: ReviewsRoute(extId: self.app.extId, reviewId: self.reviewId), auth: self.auth).get {
            (response: AppReviewsResponse?, _) in
            if let review = response?.reviews.list.first {
                self.review = review
                self.items = self.createItems(review: review)
                completion(review)
            } else {
                completion(Review.empty)
            }
        }
    }
    
    func updateAnswer(answer: ReviewAnswer, completion: @escaping () -> Void) {
        if let _ = self.items.last as? Reply {
            self.items[self.items.count - 1] = Reply(answer: answer)
        } else {
            self.items.append(Reply(answer: answer))
        }
        completion()
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
            cell.bind(answer: reply.answer)
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
                    items.append(Reply(answer: review.answer))
                }
            }
        }
        items.append(Feedback(review: review))
        if review.answered {
            items.append(Reply(answer: review.answer))
        }
        return items
    }
}
