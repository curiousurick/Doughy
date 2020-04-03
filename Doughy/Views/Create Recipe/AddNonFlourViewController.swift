//
//  AddNonFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let errorMessage = "Please fill out the ingredient details and try again."

class AddNonFlourViewController: AddIngredientViewController {
    
    override var percentRowTitle: String {
        get { return "Percent (compared to total flour)" }
    }
    
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
    
    override func isReady() -> Bool {
        return self.recipeBuilder.isIngredientsReady()
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        guard isReady() else {
            let alert = AlertViewHelper.createErrorAlert(title: "Error",
                                                         message: errorMessage,
                                                         completion: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "AddInstructionsSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddInstructionsSegue" {
            let vc = segue.destination as! AddInstructionsViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
}
