//
//  Networking.swift
//  RazeCore
//
//  Created by Gene Bogdanovich on 16.05.22.
//

import Foundation

protocol NetworkingSession {
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkingSession {
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { data, _, error in
            completionHandler(data, error)
        }
        task.resume()
    }
    
    
}

extension RazeCore {
    public class Networking {
        
        /// Responsible for handing all networking calls
        /// - Warning: Must create before using any public APIs.
        public class Manager {
            public init() {}
            
            internal var session: NetworkingSession = URLSession.shared
            
            
            /// Calls to the live internet to retrieve Data from a specific location
            /// - Parameters:
            ///   - url: The location you wish to fetch data from
            ///   - completionHandler: Returns a result object which signifies the status of the request
            public func loadData(from url: URL, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
                session.get(from: url) { data, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completionHandler(result)
                    
                }
            }
        }
        
        public enum NetworkResult<Value> {
            case success(Value)
            case failure(Error?)
        }
    }
}
