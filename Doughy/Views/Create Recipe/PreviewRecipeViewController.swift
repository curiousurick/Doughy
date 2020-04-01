//
//  PreviewRecipeViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

fileprivate let saveMessage = "You have successfully written a recipe."
fileprivate let updateMessage = "You have successfully updated the recipe."
fileprivate let saveMessageError = "Failed to save the recipe"
fileprivate let updateMessageError = "Failed to update the recipe"
fileprivate let saveUnwindSegue = "unwindAfterSave"
fileprivate let updateUnwindSegue = "unwindAfterUpdate"

class PreviewRecipeViewController: ShowCalculatedRecipeBaseViewController {
    
    private let recipeWriter = RecipeWriter.shared
    private var recipeNav: CreateRecipeNavigationController!
    
    var recipe: Recipe!
    var recipeBuilder: RecipeBuilder!

    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonClicked))
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.recipeNav = self.navigationController as? CreateRecipeNavigationController
        if self.recipeNav.editingRecipe {
            saveButton.title = "Update"
        }
        
        self.title = "Preview"

        // Do any additional setup after loading the view.
    }
    
    @objc func saveButtonClicked() {
        print("Save button clicked")
        if self.recipeNav.editingRecipe {
            self.updateRecipe()
        }
        else {
            self.saveRecipe()
        }
        NotificationCenter.default.post(name: .recipeUpdated, object: nil)
        let message = self.recipeNav.editingRecipe ? updateMessage : saveMessage
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            let segue = self.recipeNav.editingRecipe ? updateUnwindSegue : saveUnwindSegue
            self.performSegue(withIdentifier: segue, sender: nil)
        })
        alert.addAction(okaction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateRecipe() {
        let existingName = recipeBuilder.existingName ?? recipe.name
        let existingCollection = recipeBuilder.existingCollection ?? recipe.collection
        do {
            try recipeWriter.updateRecipe(recipe: recipe, existingName: existingName, existingCollection: existingCollection)
        }
        catch {
            let error = AlertViewHelper.createErrorAlert(title: "Oh no! 😭", message: updateMessageError) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            self.present(error, animated: true, completion: nil)
        }
    }
    
    private func saveRecipe() {
        do {
            try recipeWriter.writeRecipe(recipe: self.recipe)
        }
        catch {
            let error = AlertViewHelper.createErrorAlert(title: "Oh no! 😭", message: saveMessageError) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            self.present(error, animated: true, completion: nil)
        }
    }
}
