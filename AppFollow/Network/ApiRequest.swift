//
//  ApiRequest.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation
import Alamofire

private let session: SessionManager = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    
    return SessionManager(configuration: configuration)
}()

private enum JSONBodyParameterEncodingError: Error {
    case missingBodyParameter
}

private struct JSONBodyParameterEncoding<T: Encodable>: ParameterEncoding {

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest();
        
        if let body = parameters?["body"] as? T {
            let encoder = JSONEncoder()
            let data = try encoder.encode(body)
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
            
            return request
        } else {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: JSONBodyParameterEncodingError.missingBodyParameter))
        }
    }
    
}

class ApiRequest {
    let route: EndpointRoute
    let auth: AuthProvider
    let endpoint = Endpoint()
    
    init(route: EndpointRoute, auth: AuthProvider) {
        self.route = route
        self.auth = auth
    }
    
    func get<R: Decodable>(completion: @escaping (R?, Error?) -> Void) {
        let url = URL(string: route.path, relativeTo: endpoint.baseUrl)!
        let parameters = endpoint.sign(route: route, auth: auth.actual)
        let request = session.request(url, parameters: parameters).responseData {
            response in
            
            if let data = response.result.value {
                log.info("[Response]: \(response.result.debugDescription)")
                log.info("[Data]: \(response.data?.count ?? 0) bytes")
                log.info("[Timeline]: \(response.timeline.description)")
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(R.self, from: data)
                    completion(object, nil)
                } catch let responseDeserializeError {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        print(errorResponse)
                        completion(nil, errorResponse.error)
                    } catch {
                        print(responseDeserializeError)
                        completion(nil, responseDeserializeError)
                    }
                }
            } else {
                log.error(response.error?.localizedDescription ?? "")
                completion(nil, response.error)
            }
        }
        log.info("[Request]: \(url)")
        log.debug(request.debugDescription)
    }
    
    func post<P: Encodable>(body: P, completion: @escaping (Error?) -> Void) {
        let parameters = endpoint.sign(route: route, auth: auth.actual)
        let pathWithQuery = "\(route.path)?\(query(parameters))"
        let url = URL(string: pathWithQuery, relativeTo: endpoint.baseUrl)!
        let request = session.request(url, method: .post, parameters: ["body": body], encoding: JSONBodyParameterEncoding<P>()).response {
            (result) in
            
            if let error = result.error {
                log.error(error.localizedDescription)
            } else {
                log.info("[Response]: \(result.response.debugDescription)")
            }
            completion(result.error)
        }
        
        log.info("[Request]: \(url)")
        log.debug(request.debugDescription)
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        let urlEncoding = URLEncoding()
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += urlEncoding.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
