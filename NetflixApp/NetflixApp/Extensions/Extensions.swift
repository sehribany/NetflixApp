//
//  Extensions.swift
//  NetflixApp
//
//  Created by Şehriban Yıldırım on 19.04.2023.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
        
    }
}
