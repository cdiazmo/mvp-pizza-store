//
//  NetworkManager.swift
//  pizzajeff
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()

    private let queue = OperationQueue()
    
    private var cache: [String: Data]
    
    init() {
        cache = [String: Data]()
    }
    
    func networkRequest(url: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        if cache.keys.contains(url), let data = cache[url] {
            completionHandler(data, nil)
        } else {
            let operation = NetworkOperation(session: URLSession.shared, url: URL(string: url)!, completionHandler: { [weak self] data, error in
                self?.cache[url] = data
                completionHandler(data, error)
            })
            queue.addOperation(operation)
        }
    }
}

public enum State: String {
    case Ready, Executing, Finished
    
    fileprivate var keyPath: String {
        return "is" + rawValue
    }
}

class NetworkOperation : Operation {
        
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(session: URLSession, url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        super.init()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                self.state = .finished
                completionHandler(nil, error)
                return
            }
            if response.statusCode == 200 {
                completionHandler(data, nil)
                
            } else {
                completionHandler(nil, error)
                self.state = .finished
            }
        }.resume()
    }
}
