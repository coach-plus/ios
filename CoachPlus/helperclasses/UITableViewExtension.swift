//
//  UITableViewExtension.swift
//  CoachPlus
//
//  Created by Maurice Breit on 13.04.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(nib: String, reuseIdentifier: String) {
        self.register(nib: nib, reuseIdentifier: reuseIdentifier, bundle: nil)
    }
    
    func register(nib: String, reuseIdentifier: String, bundle:Bundle?) {
        let nib = UINib(nibName: nib, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func clearSelection() {
        if let selectedIndexPath = self.indexPathForSelectedRow {
            self.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
