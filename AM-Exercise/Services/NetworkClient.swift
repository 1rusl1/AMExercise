//
//  NetworkClient.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

protocol CancellableTask {
     func cancel()
}

extension NetworkClient {
     enum Error: Swift.Error {
         case general
         case invalid(response: URLResponse?)
         case network(error: Swift.Error, response: URLResponse?)
         case parsing(error: Swift.Error)
     }
}

enum PhotoRequestParameters: String {
     case key
     case imageType = "image_type"
     case page
     case perPage = "per_page"
}

final class NetworkClient {
     private let urlSession = URLSession.shared
     private let apiKey = "22577733-edb14e0d0f3f9c1a039c57e48"
     private let baseURL = "pixabay.com"
     
     func fetchImages(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
          guard let url = createURLWithParams(page: page, perPage: perPage) else {
               completion(.failure(.general))
               return
          }
          urlSession.dataTask(with: url) { jsonData, response, error in
               let result: Result<PhotoResponse, Error> = self.handleResponse(
                    data: jsonData,
                    error: error,
                    response: response
               )
               completion(result.map { $0.hits })
          }.resume()
     }

     func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> CancellableTask? {
          guard let url = URL(string: urlString) else {
               completion(.failure(.general))
               return nil
          }
          let task = urlSession.dataTask(with: url) { jsonData, response, error in
               if let error = error {
                    completion(.failure(.network(error: error, response: response)))
               }
               if let image = jsonData.flatMap(UIImage.init(data:)) {
                    completion(.success(image))
               } else {
                    let decodingError = NSError(domain: "com.exercise.AM-Exercise", code: -1, userInfo: nil)
                    completion(.failure(.parsing(error: decodingError)))
               }
          }
          task.resume()
          return task
     }
     
     private func createURLWithParams(page: Int, perPage: Int) -> URL? {
          var components = URLComponents()
          components.scheme = "https"
          components.host = baseURL
          components.path = "/api"
          components.queryItems = [
               URLQueryItem(name: PhotoRequestParameters.key.rawValue, value: apiKey),
               URLQueryItem(name: PhotoRequestParameters.imageType.rawValue, value: "photo"),
               URLQueryItem(name: PhotoRequestParameters.page.rawValue, value: "\(page)"),
               URLQueryItem(name: PhotoRequestParameters.perPage.rawValue, value: "\(perPage)")
          ]
          return components.url
     }
     
     private func handleResponse<Type: Decodable>(
          data: Data?,
          error: Swift.Error?,
          response: URLResponse?
     ) -> Result<Type, Error> {
          if let error = error {
               return .failure(.network(error: error, response: response))
          }
          if let jsonData = data {
               do {
                    return .success(try JSONDecoder().decode(Type.self, from: jsonData))
               } catch {
                    print("Error info: \(error)")
                    return .failure(.parsing(error: error))
               }
          } else {
               return .failure(.invalid(response: response))
          }
     }
}

extension URLSessionDataTask: CancellableTask { }
