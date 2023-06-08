//
//  Client.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 11/05/23.
//

import Foundation

enum ClientError: Error {
    case urlInvalid
    case dataInvalid
}

final class Client {
    
    init() {}
    
    func request<T: Codable>(url: String,
                             headers: [String: String] = [:],
                             onSuccess: @escaping (T) -> Void,
                             onFailure: @escaping (Error) -> Void ) {
        guard let url = URL(string: url) else {
            onFailure(ClientError.urlInvalid)
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(error)
            } else {
                guard let data = data else {
                    onFailure(ClientError.dataInvalid)
                    return
                }
                do {
                   let model = try JSONDecoder().decode(T.self, from: data)
                    onSuccess(model)
                } catch (let error){
                    onFailure(error)
                }
            }
        }.resume()
    }
    
}
