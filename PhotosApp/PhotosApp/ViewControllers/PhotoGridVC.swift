//
//  PhotoGridVC.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/12/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Cocoa

class PhotoGridVC: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    var photos: [PhotoListDisplayable]? = nil {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCollectionVIewItem.classForCoder(), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PhotoCollectionVIewItem"))
    }
    
}

extension PhotoGridVC : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PhotoCollectionVIewItem"), for: indexPath)
        guard let collectionViewItem = item as? PhotoCollectionVIewItem else {return item}
        
        guard let photos = photos else {
            return item
        }
        let data = photos[indexPath.item]
        collectionViewItem.imageView?.image = NSImage.init(contentsOf: data.fileURL)
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    
}
