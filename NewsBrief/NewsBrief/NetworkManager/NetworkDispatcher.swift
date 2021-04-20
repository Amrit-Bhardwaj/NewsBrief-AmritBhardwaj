//
//  NetworkDispatcher.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/* This enum is used to describe the possible network errors
 */
public enum NetworkErrors: Error {
    case badInput
    case noData
}

/* This class is used to dispatch all incoming requests to the backend server
 */
public class NetworkDispatcher: Dispatcher {

    private var environment: Environment
    
    private var session: URLSession
    
    required public init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    /* This function is used to execute an incoming request over the server
     */
    public func execute(request: Request, success: @escaping ((Response) -> Void), failure: @escaping ((Error?) -> Void)) throws {
        let req = try self.prepareURLRequest(for: request)
        let task = self.session.dataTask(with: req) { (data, response, error) in
            if error == nil {
                let response = Response((r: response as? HTTPURLResponse, data: data, error: error), for: request)
                success(response)
            } else {
                failure(error)
            }
        }
        task.resume()
    }
    
    /* This function is used to create the url request using the base url and relative path
     */
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        // Compose the url
        
        // TODO: - remove if else
        var full_url = ""
        if request.path == "" {
            full_url = "\(environment.host)"
        } else {
            full_url = "\(environment.host)/\(request.path)"
        }
        
        //let full_url = "\(environment.host)/\(request.path)"
        var url_request = URLRequest(url: URL(string: full_url)!)
        
        // Working with parameters
        switch request.parameters {
        case .body(let params):
            // Parameters are part of the body
            if let params = params as? [String: String] { // just to simplify
                url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params):
            // Parameters are part of the url
            if let params = params as? [String: String] { // just to simplify
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: full_url) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = query_params
                url_request.url = components.url
            } else {
                url_request.url = URLComponents(string: full_url)?.url
                //throw NetworkErrors.badInput
            }
        }
        
        // Add headers from enviornment and request
        environment.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        // Setup HTTP method
        url_request.httpMethod = request.method.rawValue
        
        return url_request
    }
}

