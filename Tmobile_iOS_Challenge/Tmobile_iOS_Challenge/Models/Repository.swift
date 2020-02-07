//
//  Repository.swift
//  Tmobile_iOS_Challenge
//
//  Created by Eric Ousouphan on 2/7/20.
//  Copyright © 2020 Eric Ousouphan. All rights reserved.
//

import Foundation

struct Repository: Decodable {
  let name: String
  let forks: Int
  let stars: Int
  let htmlURL: URL
  
  enum CodingKeys: String, CodingKey {
    case name
    case forks
    case stars = "stargazers_count"
    case htmlURL = "html_url"
  }
}
