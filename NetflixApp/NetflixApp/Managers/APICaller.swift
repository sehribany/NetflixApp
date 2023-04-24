//
//  APICaller.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import Foundation

//Constants

struct Constants{
    
    static let API_KEY = "fc580df82c9e7a694590f0649fe479f4"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let YoutubeAPI_KEY = "AIzaSyDpk-2m2npEn78ng7V5NHZGwP0uYHWQ3qo"
    
}

// Enums
enum APIError: Error{
    
    case failedTogetData
    
}

class APICaller{
    
    static let shared = APICaller()
    
    //Get TrendingMovie API
    
    func getTrendingMovies(compleation : @escaping (Result < [Title], Error >) ->Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    //Get TrendingTV API
    func getTrendingTv(compleation : @escaping (Result < [Title], Error >) ->Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    //Get Upcomming API
    
    func getUpcomingMovies(compleation : @escaping (Result < [Title], Error >) ->Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
                
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    //Get Populer API
    
    func getPopular(compleation : @escaping (Result < [Title], Error >) ->Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
               
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // Get TopRated API
    func getTopRated(compleation : @escaping (Result < [Title], Error >) ->Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
            
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // Get Discover API
    
    func getDiscoverMovies(compleation : @escaping (Result < [Title], Error >) ->Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
            
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // Get Search
    
    func search(with query : String , compleation : @escaping (Result < [Title], Error >) ->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                compleation(.success(results.results))
            
                
            }catch{
                compleation(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // Get Youtube API
    
    func getMovie(with query : String , compleation : @escaping (Result < VideoElement, Error >) ->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data  = data, error == nil else{ return }
            
            do{
                
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self , from: data)
                compleation(.success(results.items[0]))
                print(results)
            
                
            }catch{
                compleation(.failure(error))
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}

