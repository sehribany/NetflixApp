//
//  DataPersistenceManager.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 24.04.2023.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager{
    
    // Enums
    enum DatabaseError: Error {
        
        case failedToSaved
        case failedToFetchData
        case failedToDelete
        
    }
    
    static let shared = DataPersistenceManager()
    
    // Save To CoreData
    
    func downloadTitleWith(model: Title, completion: @escaping ( Result <Void, Error> ) -> Void ){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item    = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.overview       = model.overview
        item.poster_path    = model.poster_path
        item.id             = Int64(model.id)
        item.original_name  = model.original_name
        item.media_type     = model.media_type
        item.release_date   = model.release_date
        item.vote_average   = model.vote_average
        item.vote_count     = Int64(model.vote_count)
        
        do{
            
            try context.save()
            completion(.success(()))
            
        }catch{
            
            completion(.failure(DatabaseError.failedToSaved))
        }
    }
    
    // Fetch Data From CoreData
    
    func fetchingTitlesFromDatabase(completion: @escaping ( Result <[TitleItem], Error> ) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context           = appDelegate.persistentContainer.viewContext
        
        let request           : NSFetchRequest<TitleItem>
        
        request               = TitleItem.fetchRequest()
        
        do{
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch{
            
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    // Delete Data From CoreData
    
    func deleteTitleWith(model: TitleItem, completion: @escaping ( Result <Void, Error> ) -> Void ){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context           = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            
            try context.save()
            completion(.success(()))
            
        }catch{
            
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
    
    
}
