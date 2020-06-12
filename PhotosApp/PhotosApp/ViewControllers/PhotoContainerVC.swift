//
//  PhotoContainerVC.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/12/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Cocoa

class PhotoContainerVC: NSViewController {

    @IBOutlet weak var gridContainerView: NSView!
    @IBOutlet weak var listContainerView: NSView!
    
    var prefs = Preferences()
    var photos: [PhotoListDisplayable]? = nil
    
    weak var listVC: PhotoListViewController!
    weak var gridVC: PhotoGridVC!
    
    var imageSearchDirectories: [NSURL]? = nil {
        didSet {
            loadImages()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if imageSearchDirectories == nil {
            imageSearchDirectories = [NSURL.init(fileURLWithPath: "/Users/arshadtp/Desktop"),
                                      NSURL.init(fileURLWithPath: "/Users/arshadtp/Downloads"),
                                      NSURL.init(fileURLWithPath: "/Users/arshadtp/Documents")]

        }
        setupPrefs()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destinationController as? PhotoListViewController {
            listVC = vc
        } else if let vc = segue.destinationController as? PhotoGridVC {
            gridVC = vc
        }
        if photos != nil {
            loadData(for: prefs.viewStyle)
        }
    }
    
    func updateDisplay(for style: PhotoListStyle) {
        switch style {
        case .list:
            listContainerView.isHidden = false
            gridContainerView.isHidden = true
        case .grid:
            listContainerView.isHidden = true
            gridContainerView.isHidden = false

        }
    }
    
    func loadData(for style: PhotoListStyle) {
        switch style {
        case .list:
            listVC?.photos = photos
        case .grid:
            gridVC?.photos = photos

        }
    }
    
    private func loadImages() {
        guard let imageSearchDirectories = imageSearchDirectories else {
            return
        }
        
        photos = [PhotoListDisplayable]()
        for url in imageSearchDirectories {
            ContentLoader.loadImagesFrom(directory: url) { (images, error) in
                if let images = images {
                    self.photos? += images
                    DispatchQueue.main.async {
                        self.loadData(for: self.prefs.viewStyle)
                    }
                }
            }
        }
    }
}

extension PhotoContainerVC {

  // MARK: - Preferences

    func setupPrefs() {
        
        updateDisplay(for: prefs.viewStyle)
        
        let notificationName = Notification.Name(rawValue: ViewStylePreferenceVC.kPreferecePhotoDisplayStyleChangeNotification)
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                DispatchQueue.main.async {
                                                    self.updateDisplay(for: self.prefs.viewStyle)
                                                    self.loadData(for: self.prefs.viewStyle)
                                                }

        }
    }
}
