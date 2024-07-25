//
//  NetworkManager.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func sendRequest<T: Decodable>(ofType: T.Type, handler: @escaping (T)->Void) {
        do {
            let request = try Router.topic(topic: .goldenHour).asURLRequest()
            print(request.url?.absoluteString)
            AF.request(request)
                .responseString { response in
                    print(response.response?.statusCode)
                    switch response.result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print("AF Request Failed", error)
                    }
            }
        } catch {
            print(error)
        }
    }
}
