//
//  NetworkManager.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import Foundation

struct NetworkManager {
    typealias RailCompletionClosure = ((PageModel?, Error?) -> Void)
    
    public func fetchMovieData(completion: RailCompletionClosure?) {
        guard let request = createRequest(for: "https://raw.githubusercontent.com/atulkhatri/random/master/bootcamp-home-movies.json") else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    public func fetchSeriesData(completion: RailCompletionClosure?) {
        guard let request = createRequest(for: "https://raw.githubusercontent.com/atulkhatri/random/master/bootcamp-home-series.json") else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    private func createRequest(for url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decodedResponse, nil)
                }
            } else {
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidData
}
