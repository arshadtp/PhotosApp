//
//  ContentLoader.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/9/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Foundation
import Cocoa

struct ContentLoader {
    
    static func loadContentsFrom(directory url: NSURL, completion: @escaping  (_ result:[Metadata]?, _ error: Error?) -> ())   {
        
        DispatchQueue.global().async {
            let requiredAttributes = [URLResourceKey.localizedNameKey, URLResourceKey.effectiveIconKey,
                                      URLResourceKey.typeIdentifierKey, URLResourceKey.contentModificationDateKey,
                                      URLResourceKey.fileSizeKey, URLResourceKey.isDirectoryKey,
                                      URLResourceKey.isPackageKey]
            if let enumerator = FileManager.default.enumerator(at: url as URL,
                                                               includingPropertiesForKeys: requiredAttributes,
                                                               options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants],
                                                               errorHandler: nil) {
                
                var contents = [Metadata]()
                while let url = enumerator.nextObject() as? URL {
                    print("\(url)")
                    
                    do {
                        let properties = try  (url as NSURL).resourceValues(forKeys: requiredAttributes)
                        contents.append(Metadata(fileURL: url,
                                                 name: properties[URLResourceKey.localizedNameKey] as? String ?? "",
                                                 date: properties[URLResourceKey.contentModificationDateKey] as? Date ?? Date.distantPast,
                                                 size: (properties[URLResourceKey.fileSizeKey] as? NSNumber)?.int64Value ?? 0,
                                                 icon: properties[URLResourceKey.effectiveIconKey] as? NSImage  ?? NSImage(),
                                                 isFolder: (properties[URLResourceKey.isDirectoryKey] as? NSNumber)?.boolValue ?? false,
                                                 color: NSColor()))
                    }
                    catch {
                        print("Error reading file attributes")
                        completion(nil, error)
                        return
                    }
                }
                completion(contents, nil)
                return
            }
            completion(nil, nil)

        }
    }
    
    static func loadImagesFrom(directory url: NSURL, completion:  @escaping (_ result:[Metadata]?, _ error: Error?) -> ()){
        
        loadContentsFrom(directory: url) { (contents, error) in
            if let contents =  contents {
                let images = contents.filter { return Utilities.isImageFile(name: $0.name)}
                completion(images, nil)
            } else {
                completion(contents, error)
            }
        }
    }
}

public struct Metadata: CustomDebugStringConvertible, Equatable {
    
    let name: String
    let date: Date
    let size: Int64
    let icon: NSImage
    let color: NSColor
    let isFolder: Bool
    let url: URL
    
    init(fileURL: URL, name: String, date: Date, size: Int64, icon: NSImage, isFolder: Bool, color: NSColor) {
        self.name = name
        self.date = date
        self.size = size
        self.icon = icon
        self.color = color
        self.isFolder = isFolder
        self.url = fileURL
    }
    
    public var debugDescription: String {
        return name + " " + "Folder: \(isFolder)" + " Size: \(size)"
    }
    
}
