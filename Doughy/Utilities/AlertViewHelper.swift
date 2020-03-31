//
//  DismissViewHelper.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class AlertViewHelper: NSObject {
    
    static func createDismissAlert(discardCompletion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "Discard changes?", message: "Your changes will be lost", preferredStyle: .actionSheet)
        
        let discardAction = UIAlertAction(title: "Discard", style: .destructive, handler: discardCompletion)
        let keepEditing = UIAlertAction(title: "Keep Editing", style: .default, handler: nil)
        alert.addAction(discardAction)
        alert.addAction(keepEditing)
        return alert
    }
    
    static func createErrorAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
        return alert
    }

}
