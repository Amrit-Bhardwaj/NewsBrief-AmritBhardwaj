//
//  UserRequests.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/* This enum represents a request object to backend server
 */
public enum UserRequests: Request {

    case login(username: String, password: String)
    case articleDetails(country: String, category: String, apiKey: String, pageSize: String, page: String)
    case downloadImage(path: String)
    case articleMeta(path: String)
    
    public var path: String {
        switch self {
        case .login(_,_):
            return "users/login"
        case .articleDetails:
            return "v2/top-headlines"
        case .downloadImage(let path):
            return path
        case .articleMeta(let path):
            return path
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login(_,_):
            return .post
        case .articleDetails, .downloadImage(_), .articleMeta(_):
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .login(let username, let password):
            return .body(["user" : username, "pass" : password])
        case .articleDetails(let country, let category, let apiKey, let pageSize, let page):
            return .url(["country" : country, "category": category, "apiKey" : apiKey, "pageSize": pageSize, "page": page])
        case .downloadImage(_):
            return .url(nil)
        case .articleMeta(_):
            return .url(nil)
        }
    }

    public var headers: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var dataType: DataType {
        switch self {
        case .login(_,_):
            return .JSON
        case .articleDetails(_,_,_,_,_), .articleMeta(_):
            return .JSON
        case .downloadImage:
            return .Data
        }
    }
}

