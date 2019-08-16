//
//  APIClient.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift

#warning("TODO: Create unit test for API Client")
class APIClient {
    var authManager: AuthManagerProtocol?
    var appToken: String?

    private(set) var baseURL: URL
    private var dateFormatter = DateFormatter()
    private let jsonDecoder = JSONDecoder()
    private var session: URLSessionProtocol

    init(baseURL: String, session: URLSessionProtocol = URLSession.shared, authManager: AuthManagerProtocol) {
        self.baseURL = URL(string: baseURL)!
        self.session = session
        self.authManager = authManager

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    private func handleNoConnectionError<T: Codable>(error: Error,
                                                     to observer: AnyObserver<Result<T, Error>>) {
        DispatchQueue.main.async {
            // Check here if the error is that there is no connection
            debugPrint("No connection")
            observer.onNext(Result.failure(error))
        }
    }

    private func process<T: Codable>(data: Data?, with observer: AnyObserver<Result<T, Error>>) {
        do {
            let model: T = try jsonDecoder.decode(T.self, from: data ?? Data())
            DispatchQueue.main.async {
                observer.onNext(.success(model))
            }
        } catch let decodingError {
            DispatchQueue.main.async {
                debugPrint("Error decoding \(T.self)")
                debugPrint(decodingError)
                observer.onNext(.failure(decodingError))
            }
        }
        DispatchQueue.main.async {
            observer.onCompleted()
        }
    }

    private func process<T: Codable>(errorData: Data,
                                     statusCode: Int,
                                     with observer: AnyObserver<Result<T, Error>>) {
        do {
            let errorResponseInfo = try jsonDecoder.decode(ResponseInfo.self, from: errorData)
            let errorMessage = errorResponseInfo.error ?? "Something went wrong"
            let error = NSError(domain: "",
                                code: statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
            observer.onNext(.failure(error))
        } catch let decodingError {
            DispatchQueue.main.async {
                debugPrint("Error decoding \(T.self)")
                debugPrint(decodingError)
                observer.onNext(.failure(decodingError))
            }
        }
    }

    private func urlRequest(for request: Request) -> URLRequest {
        var urlRequest = request.urlRequest(withBaseURL: baseURL)

        // Add Authorization Header if the Request needs authorization
        if let token = authManager?.userToken, request.endpoint.authNeeded {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }

    func send<T: Codable>(request: Request) -> Observable<Result<T, Error>> {
        let observer = Observable<Result<T, Error>>.create { [unowned self] observer in
            let request = self.urlRequest(for: request)

            let task = self.session.dataTask(with: request) { [weak self] data, urlResponse, error in
                // Check here if the url response has an error
                if let data = data,
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                    jsonData as? [String: Any] != nil,
                    let httpURLResponse = urlResponse as? HTTPURLResponse,
                    httpURLResponse.statusCode >= 400 {
                    if let error = error {
                        observer.onNext(.failure(error))
                    } else {
                        self?.process(errorData: data, statusCode: httpURLResponse.statusCode, with: observer)
                    }
                } else if let error = error {
                    self?.handleNoConnectionError(error: error, to: observer)
                } else {
                    self?.process(data: data, with: observer)
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }

        return observer
    }
}
