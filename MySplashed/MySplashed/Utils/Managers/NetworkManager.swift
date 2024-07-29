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
    
    func sendRequest<T: Decodable>(_ router: Router, ofType type: T.Type, completionHandler: @escaping (Result<T, NetworkManagerError>)->Void) {
        do {
            let request = try router.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: type) { response in
                    switch response.result {
                        case .success(let value):
                        completionHandler(.success(value))
                        case .failure:
                        //TODO: Network Error Handling하기
                        completionHandler(.failure(NetworkManagerError.fetchResponseFailed))
                        }
                }
        } catch {
            completionHandler(.failure(NetworkManagerError.fetchResponseFailed))
        }
    }
}

enum NetworkManagerError: Error {
    case fetchResponseFailed
}
