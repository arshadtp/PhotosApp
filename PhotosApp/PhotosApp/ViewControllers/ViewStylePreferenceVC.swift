//
//  ViewStylePreferenceVC.swift
//  PhotosApp
//
//  Created by Arshad T P on 6/12/20.
//  Copyright © 2020 Ab'initio. All rights reserved.
//

import Cocoa


class ViewStylePreferenceVC: NSViewController {

    @IBOutlet weak var viewStyleSelectorButton: NSSegmentedControl!
    var prefs = Preferences()

    static let kPreferecePhotoDisplayStyleChangeNotification = "PreferecePhotoDisplayStyleChangeNotification"

    override func viewDidLoad() {
        super.viewDidLoad()
        showExistingViewStylePreferences()
    }
    
    func showExistingViewStylePreferences() {
        switch prefs.viewStyle {
        case .list:
            viewStyleSelectorButton.selectedSegment = 0
        case .grid:
            viewStyleSelectorButton.selectedSegment = 1
        }
    }
    
    @IBAction func viewStyleSelectorButtotnAction(_ sender: NSSegmentedControl) {
        
        prefs.viewStyle = PhotoListStyle.init(rawValue: sender.selectedSegment) ?? .list
        NotificationCenter.default.post(name: Notification.Name(rawValue: ViewStylePreferenceVC.kPreferecePhotoDisplayStyleChangeNotification),
                                        object: nil)
    }
}
