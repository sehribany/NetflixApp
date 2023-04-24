//
//  Movie.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import Foundation

struct TitleResponse: Codable {
    let page: Int
    let results: [Title]
    let total_pages, total_results: Int
}

// MARK: - Result
struct Title: Codable {
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let title: String?
    let original_language: String?
    let original_title: String?
    let overview, poster_path: String
    let media_type: String?
    let genre_ids: [Int]
    let popularity: Double
    let release_date: String?
    let video: Bool?
    let vote_average: Double
    let vote_count: Int
    let name, original_name, first_air_date: String?
    let origin_country: [String]?

}

