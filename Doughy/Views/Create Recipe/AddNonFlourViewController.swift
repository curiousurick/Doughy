//
//  AddNonFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class AddNonFlourViewController: AddIngredientViewController {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func initializeBuilders() {
        if recipeBuilder.ingredientBuilders.isEmpty {
            recipeBuilder.addIngredient(ingredientBuilder: IngredientBuilder())
        }
    }
    
    override func getTitle() -> String {
        return "Add Remaining Ingredients"
    }
    
    override func getBuilders() -> [IngredientBuilderBase] {
        return recipeBuilder.ingredientBuilders
    }
    
    override func addBuilder() -> IngredientBuilderBase {
        recipeBuilder.addIngredient(ingredientBuilder: IngredientBuilder())
        return recipeBuilder.ingredientBuilders.last!
    }
    
    override func removeBuilder(builder: IngredientBuilderBase) {
        let ingredientBuilder = builder as! IngredientBuilder
        self.recipeBuilder.removeIngredient(ingredientBuilder: ingredientBuilder)
    }
    
    override func toggleNextButton() {
        self.nextButton.isEnabled = self.recipeBuilder.isIngredientsReady()
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddInstructionsSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddInstructionsSegue" {
            let vc = segue.destination as! AddInstructionsViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
}
