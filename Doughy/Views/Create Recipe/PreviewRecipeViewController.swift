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
fileprivate let saveUnwindSegue = "unwindAfterSave"
fileprivate let updateUnwindSegue = "unwindAfterUpdate"

class PreviewRecipeViewController: ShowCalculatedRecipeViewController {
    
    private let recipeWriter = RecipeWriter.shared
    private var recipeNav: CreateRecipeNavigationController!
    
    var recipe: Recipe!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipeNav = self.navigationController as? CreateRecipeNavigationController
        if self.recipeNav.editingRecipe {
            saveButton.title = "Update"
        }
        
        self.title = "Preview"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        print("Save button clicked")
        recipeWriter.writeRecipe(recipe: self.recipe)
        let message = self.recipeNav.editingRecipe ? updateMessage : saveMessage
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            let segue = self.recipeNav.editingRecipe ? updateUnwindSegue : saveUnwindSegue
            self.performSegue(withIdentifier: segue, sender: nil)
        })
        alert.addAction(okaction)
        self.present(alert, animated: true, completion: nil)
    }
}
