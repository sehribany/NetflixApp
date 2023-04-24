//
//  YoutubeSearchResponse.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 24.04.2023.
//

import Foundation

struct YoutubeSearchResponse : Codable {
    
    let items : [VideoElement]
    
}

struct VideoElement : Codable {
    
    let id : IdVideoElement
}

struct IdVideoElement : Codable {
    let kind : String
    let videoId : String
}
