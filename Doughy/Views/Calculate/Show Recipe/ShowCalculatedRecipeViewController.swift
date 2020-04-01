//
//  ShowCalculatedRecipeViewController.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

fileprivate let saveErrorTitle = "Error"
fileprivate let saveErrorMessage = "Failed to save this recipe."
fileprivate let saveSuccessTitle = "Success!"
fileprivate let saveSuccessMessage = "Go to the history tab to see this recipe and take notes on how it turned out!"

class ShowCalculatedRecipeViewController: ShowCalculatedRecipeBaseViewController {
    
    private let recipeWriter = CalculatedRecipeWriter.shared
    
    var saveRecipeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveRecipeButton = UIBarButtonItem()
    }
    
    func saveRecipeButtonClicked(_ sender: Any) {
        
        do {
            try recipeWriter.writeRecipe(recipe: self.calculatedRecipe)
        }
        catch {
            let alert = AlertViewHelper.createErrorAlert(title: saveErrorTitle, message: saveErrorMessage) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: saveSuccessTitle, message: saveSuccessMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Go home", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
