//
//  CreateRecipeNavigationController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CreateRecipeNavigationController: UINavigationController, UIAdaptivePresentationControllerDelegate {
    
    var editingRecipe = false
    var recipeBuilder: RecipeBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipeBuilder != nil {
            editingRecipe = true
        }
        else {
            recipeBuilder = RecipeBuilder()
        }
        
        (self.children[0] as? CreateRecipeViewController)?.recipeBuilder = recipeBuilder
        
        self.presentationController?.delegate = self
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        }
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !(recipeBuilder?.isModified ?? false)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = DismissViewHelper.createDismissAlert { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
