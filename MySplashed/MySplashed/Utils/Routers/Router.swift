//
//  Router.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

import Alamofire

enum Router {
    case topic(topic: TopicType)
    case search(searchText: String, page: Int = 1)
}

extension Router: URLRequestConvertible {
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .topic(_):
            return "/topics"
        case .search:
            return "/search"
        }
    }
    
    var trailingPath: String {
        switch self {
        case .topic(topic: let topic):
            return "/"+topic.rawValue + "/photos"
        case .search(_, _):
            return "/photos"
        }
    }
    
    var header: [String : String] {
        let accessKey = Bundle.main.object(forInfoDictionaryKey: "ACCESS_KEY") as? String ?? ""
        return [
            "contentType" : "application/json",
            "Accept-Version" : "v1",
            "Authorization" : accessKey
        ]
    }
    
    var parameters: [String:String] {
        switch self {
        case .topic:
            return [:]
        case .search(searchText: let searchText, page: let page):
            return [
                "query" : searchText,
                "per_page" : "20",
                "page" : String(page)
            ]
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
    
    var encoding: ParameterEncoding {
        switch self {
        case .topic(_):
            return URLEncoding.default
        case .search(_):
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try (baseURL + path).asURL()
        var request = try URLRequest(
            url: url.appendingPathComponent(trailingPath),
            method: method
        )
        request.allHTTPHeaderFields = header
        let encodedRequest = try encoding.encode(request, with: parameters)
        return encodedRequest
    }
}
