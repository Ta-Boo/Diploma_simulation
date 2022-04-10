//
//  APIManager.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation

struct Routing {
    static let baseURL = "http://0.0.0.0:8080/v1"
    static let activeDrivers = "/active_drivers"
    static let drivers = "/drivers"
    static let customers = "/users"
    static let restaurants = "/restaurants"
    static let assignOrder = "/orders/assign"
    static let createOrder = "/orders/create"
    static let pickupOrder = "/orders/pickup"
    static let deliverOrder = "/orders/deliver"
    static let activateDriver = "/activate_driver"
    static let deActivateDriver = "/deactivate_driver"
    static let reset = "/reset"
    static func getOrder(id: Int) -> String  { return "/orders/find//\(id)" }
    
}

class APIManager {
    enum ErrorType: Error {
        case wrongURL
        case missingFields
        case emptyResponse
        case unknown
    }
    
    
    static func fetchData<T: Decodable>(
        from urlString: String,
        parameters: [URLQueryItem] = [],
        completionClosure : @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: Routing.baseURL + urlString)
        if !parameters.isEmpty {
            components?.queryItems = parameters
        }
        guard let url = components?.url else {
            completionClosure(.failure(ErrorType.wrongURL))
            return
        }
//        print("URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionClosure(.failure(error))
                return
            }
            
            guard let data = data else {
                completionClosure(.failure(ErrorType.emptyResponse))
                return
            }
            
            do {
                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionClosure(.success(result))
                }
            } catch {
                completionClosure(.failure(error))
            }
            
        }.resume()
    }
    
    static func post<T: Decodable>(
        from urlString: String,
        parameters: [String: Any] = [:],
        completionClosure : @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: Routing.baseURL + urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue("no-cache", forHTTPHeaderField: "cache-control")
        request.httpMethod = "POST"
        let body = parameters.percentEncoded()
        request.httpBody = body
//        print("URL: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, failureReason in
            if let failureReason = failureReason {
                completionClosure(.failure(failureReason))
                return
            }
            
            guard let data = data else {
                completionClosure(.failure(ErrorType.emptyResponse))
                return
            }
            
            let response = response as! HTTPURLResponse
            if (300...600).contains(response.statusCode) {
                print(response.statusCode)
                completionClosure(.failure(ErrorType.unknown))
                return
            }
            
            do {
                if ("" is T) {
                    DispatchQueue.main.async {
                        completionClosure(.success(String(decoding: data, as: UTF8.self) as! T))
                    }
                    return
                }
                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionClosure(.success(result))
                }
            } catch {
                completionClosure(.failure(error))
            }
            
        }.resume()
    }
    
    
    static func syncPost<T: Decodable>(
        from urlString: String,
        parameters: [String: Any] = [:],
        completionClosure : @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: Routing.baseURL + urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue("no-cache", forHTTPHeaderField: "cache-control")
        request.httpMethod = "POST"
        let body = parameters.percentEncoded()
        request.httpBody = body
//        print("URL: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, failureReason in
            if let failureReason = failureReason {
                completionClosure(.failure(failureReason))
                return
            }
            
            guard let data = data else {
                completionClosure(.failure(ErrorType.emptyResponse))
                return
            }
            
            let response = response as! HTTPURLResponse
            if (300...600).contains(response.statusCode) {
                print(response.statusCode)
                completionClosure(.failure(ErrorType.unknown))
                return
            }
            
            do {
                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let result = try decoder.decode(T.self, from: data)
                completionClosure(.success(result))
            } catch {
                completionClosure(.failure(error))
            }
            
        }.resume()
    }
}
