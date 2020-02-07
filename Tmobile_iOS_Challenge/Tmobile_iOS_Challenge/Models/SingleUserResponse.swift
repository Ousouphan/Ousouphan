//
//  SpecificUserResponse.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation

struct SingleUserResponse: Decodable {
  let userURL: String
  
  enum CodingKeys: String, CodingKey {
    case userURL = "url"
  }
}
