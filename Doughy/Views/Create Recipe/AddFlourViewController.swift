//
//  AddFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class AddFlourViewController: AddIngredientViewController {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func initializeBuilders() {
        if recipeBuilder.flourBuilder == nil {
            recipeBuilder.flourBuilder = IngredientsBuilder(isFlour: true)
        }
    }
    
    override func getTitle() -> String {
        return "Add Flours"
    }
    
    override func getBuilders() -> IngredientsBuilder? {
        return recipeBuilder.flourBuilder
    }
    
    override func addBuilder() -> IngredientBuilder {
        let builder = IngredientBuilder(isFlour: true)
        recipeBuilder.flourBuilder!.addBuilder(builder: builder)
        return builder
    }
    
    override func removeBuilder(builder: IngredientBuilder) {
        self.recipeBuilder.flourBuilder?.removeBuilder(builder: builder)
    }
    
    override func toggleNextButton() {
        self.nextButton.isEnabled = self.recipeBuilder.flourBuilder!.isReady()
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "MoveToRestOfIngredientsSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToRestOfIngredientsSegue" {
            let vc = segue.destination as! AddNonFlourViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
}
