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
        if recipeBuilder.ingredientsBuilder == nil {
            recipeBuilder.ingredientsBuilder = IngredientsBuilder(isFlour: false)
        }
    }
    
    override func getTitle() -> String {
        return "Add Remaining Ingredients"
    }
    
    override func getBuilders() -> IngredientsBuilder? {
        return recipeBuilder.ingredientsBuilder
    }
    
    override func addBuilder() -> IngredientBuilder {
        let builder = IngredientBuilder(isFlour: false)
        recipeBuilder.ingredientsBuilder!.addBuilder(builder: builder)
        return builder
    }
    
    override func removeBuilder(builder: IngredientBuilder) {
        self.recipeBuilder.ingredientsBuilder?.removeBuilder(builder: builder)
    }
    
    override func toggleNextButton() {
        self.nextButton.isEnabled = self.recipeBuilder.ingredientsBuilder!.isReady()
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
