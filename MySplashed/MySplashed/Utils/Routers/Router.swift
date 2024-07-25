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
    case search(text: String)
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
        case .search(let text):
            return "/"+text + "/photos"
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
        let url = try (baseURL + path).asURL()
        var request = try URLRequest(
            url: url.appendingPathComponent(trailingPath),
            method: method
        )
        request.allHTTPHeaderFields = header
        
        return request
    }
}



enum TopicType: String, CaseIterable {
    case goldenHour = "golden-hour"
    case business = "business-work"
    case architecture = "architecture-interior"
}
