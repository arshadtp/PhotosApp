//
//  ViewController.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/8/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Cocoa

protocol PhotoListDisplayable {
    var fileName: String { get }
    var updatedDate: Date { get }
    var size: Int64 { get }
    var fileURL: URL { get }
}

extension Metadata: PhotoListDisplayable {
    
    var fileName: String {
        return name
    }
    
    var updatedDate: Date {
        return date
    }
    
    var fileURL: URL {
        return url
    }
}


class PhotoListViewController: NSViewController {
    
    @IBOutlet weak var photoListView: NSTableView!
    
    var dataSource: [PhotoListDisplayable]? = nil
    
    var imageSearchDirectories: [NSURL]? = nil {
        didSet {
            loadImages()
        }
    }
    
    private let sizeFormatter = ByteCountFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageSearchDirectories == nil {
            imageSearchDirectories = [NSURL.init(fileURLWithPath: "/Users/arshadtp/Desktop"),
                                      NSURL.init(fileURLWithPath: "/Users/arshadtp/Downloads"),
                                      NSURL.init(fileURLWithPath: "/Users/arshadtp/Documents")]

        }
//        loadImages()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func loadImages() {
        
        guard let imageSearchDirectories = imageSearchDirectories else {
            return
        }
        
        dataSource = [PhotoListDisplayable]()
        for url in imageSearchDirectories {
            if let photos = ContentLoader.loadImagesFrom(directory: url) {
                dataSource? += photos
            }
        }
        photoListView.reloadData()
    }
}


extension PhotoListViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource?.count ?? 0
    }
}

extension PhotoListViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let DateCell = "DateCellID"
        static let SizeCell = "SizeCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let item = dataSource?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            image = NSImage.init(contentsOf: item.fileURL)
            text = item.fileName
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.updatedDate)
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = sizeFormatter.string(fromByteCount: item.size)
            cellIdentifier = CellIdentifiers.SizeCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
}

