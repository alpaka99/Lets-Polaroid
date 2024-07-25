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
    
    func sendRequest<T: Decodable>(ofType: T, handler: @escaping (T)->Void) {
        
    }
}
