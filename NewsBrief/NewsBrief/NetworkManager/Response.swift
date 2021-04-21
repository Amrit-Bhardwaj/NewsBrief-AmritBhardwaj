//
//  Response.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/* This enum is used to resolve the API response object
 */
public enum Response {
    
    case json(_: [String: AnyObject])
    case data(_: Data)
    case error(_: Int?, _: Error?)
    
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard response.r?.statusCode == 200, response.error == nil else {
            self = .error(response.r?.statusCode, response.error)
            return
        }
        
        switch request.dataType {
        
        case .Data:
            guard let data = response.data else {
                self = .error(response.r?.statusCode, NetworkErrors.noData)
                return
            }
            self = .data(data)
            
        case .JSON:
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject] else {
                self = .error(response.r?.statusCode, NetworkErrors.noData)
                return
            }
            self = .json(json)
        }
    }
}

