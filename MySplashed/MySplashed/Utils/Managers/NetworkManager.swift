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
    
    func sendRequest<T: Decodable>(_ router: Router, ofType type: T.Type, completionHandler: @escaping (T)->Void) {
        do {
            let request = try router.asURLRequest()
            
            AF.request(request)
                .responseDecodable(of: type) { response in
                    switch response.result {
                        case .success(let value):
                            completionHandler(value)
                        case .failure(let error):
                        //TODO: Network Error Handling하기
                            print("AF Request Failed", error)
                        }
                }
//                .responseString { response in
//                    print(response.response?.statusCode)
//                    switch response.result {
//                    case .success(let value):
//                        print(value)
//                    case .failure(let error):
//                        print("AF Request Failed", error)
//                    }
//            }
        } catch {
            print(error)
        }
    }
}
