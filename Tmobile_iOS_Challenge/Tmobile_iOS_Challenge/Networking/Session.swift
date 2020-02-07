//
//  Session.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation
import UIKit

protocol Session {
  func retriveModel<T: Decodable>(from url: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

protocol ImageSession {
  func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
