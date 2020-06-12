//
//  Preferences.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/12/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Foundation

enum PhotoListStyle:Int {
    case list
    case grid
}


struct Preferences {

  var viewStyle: PhotoListStyle {
    get {
        
      let style = UserDefaults.standard.integer(forKey: "viewStyle")
      
        return PhotoListStyle.init(rawValue: style) ?? .list
    }
    set {
        UserDefaults.standard.set(newValue.rawValue, forKey: "viewStyle")
    }
  }

}
