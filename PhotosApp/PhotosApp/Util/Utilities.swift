//
//  Utilities.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/9/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Foundation

struct Utilities {
    
    static func isImageFile(name:String) -> Bool {
        
        let componets = name.components(separatedBy: ".")
        guard let fileExt = componets.last else {
            return false
        }
        return kImageExtensions.contains(fileExt.lowercased())
        
    }
}

