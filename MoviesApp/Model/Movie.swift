//
//  Movie.swift
//  MoviesApp
//
//  Created by Diana Pava Avila on 11/05/23.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let original_title: String
    let overview: String
    let poster_path: String
    let backdrop_path: String
}


