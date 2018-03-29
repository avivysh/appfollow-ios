//
//  ApiRequest.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import Alamofire

struct ApiRequest {
    let url: URL
    let parameters: [String: Any]
    
    func send<R: Decodable>(completion: @escaping (R?) -> Void) {
        let request = Alamofire.request(self.url, parameters: self.parameters).responseData {
            response in
            print(response.timeline)
            print("")
            if let data = response.result.value {
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(R.self, from: data)
                    completion(object)
                } catch {
                    print(error)
                    completion(nil)
                }
            } else {
                print(response.error?.localizedDescription ?? "")
                completion(nil)
            }
        }
        print("REQUEST: \(self.url)")
        debugPrint(request)
    }

}
