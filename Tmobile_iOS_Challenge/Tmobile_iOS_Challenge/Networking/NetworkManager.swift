//
//  NetworkManager.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation
import UIKit

extension NetworkManager {
    private func validateImage(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkError.badData
        }
        return image
    }
    
    private func validateError(_ error: Error?) throws {
        guard let error = error else { return }
        throw error
    }
    
    private func checkForData(_ data: Data?) throws -> Data {
        guard let data = data else {
            throw NetworkError.noData
        }
        return data
    }
}

final class NetworkManager: Session, ImageSession {
    static let shared = NetworkManager()
  // please put auth token
    private let authToken = ""
    private init() { }
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let generatedURL = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: generatedURL) { [unowned self] (data, response, error) in
            do {
                try self.validateError(error)
                let data = try self.checkForData(data)
                let image = try self.validateImage(data)
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func retriveModel<T: Decodable>(from url: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("token \(self.authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            do {
                try self.validateError(error)
                let data = try self.checkForData(data)
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
