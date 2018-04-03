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
    let route: EndpointRoute
    let auth: Auth
    let endpoint = Endpoint()
    
    func get<R: Decodable>(completion: @escaping (R?) -> Void) {
        let url = URL(string: route.path, relativeTo: endpoint.baseUrl)!
        let parameters = endpoint.sign(route: route, auth: auth)
        let request = Alamofire.request(url, parameters: parameters).responseData {
            response in
            
            print("[Response]: \(response.result.debugDescription)")
            print("[Data]: \(response.data?.count ?? 0) bytes")
            print("[Timeline]: \(response.timeline.description)")
            print("")
            if let data = response.result.value {
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(R.self, from: data)
                    completion(object)
                } catch {
                    // TODO: Deserialize error
                    print(error)
                    completion(nil)
                }
            } else {
                print(response.error?.localizedDescription ?? "")
                completion(nil)
            }
        }
        print("[Request]: \(url)")
        debugPrint(request)
        print("")
    }

}
