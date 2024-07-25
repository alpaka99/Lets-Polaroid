//
//  Router.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

import Alamofire

enum Router {
    case topic
    case search
}

extension Router: URLRequestConvertible {
    
    var baseURL: String {
        return "https://api.unsplashed.com"
    }
    
    var path: String {
        switch self {
        case .topic:
            return "/topics"
        case .search:
            return "/search"
        }
    }
    
    var header: [String : String] {
        return [
            "Accept-Version" : "v1",
            "Authorization" : "Client-ID \("ACCESS KEY")"
        ]
    }
    
    var parameters: [String : String] {
        switch self {
        case .topic:
            return [
                "id_or_slug" : "",
                "per_page" : "20",
            ]
        case .search:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topic:
            return .get
        case .search:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        <#code#>
    }
}

