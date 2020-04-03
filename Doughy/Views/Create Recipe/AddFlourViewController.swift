//
//  AddFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let errorMessage = "Please fill out flour details and get total to 100%"

class AddFlourViewController: AddIngredientViewController {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func initializeBuilders() {
        if recipeBuilder.flourBuilders.isEmpty {
            recipeBuilder.addFlour(flourBuilder: FlourBuilder())
        }
    }
    
    override func getTitle() -> String {
        return "Add Flours"
    }
    
    override func getBuilders() -> [IngredientBuilderBase] {
        return recipeBuilder.flourBuilders
    }
    
    override func addBuilder() -> IngredientBuilderBase {
        recipeBuilder.addFlour(flourBuilder: FlourBuilder())
        return recipeBuilder.flourBuilders.last!
    }
    
    override func removeBuilder(builder: IngredientBuilderBase) {
        let flourBuilder = builder as! FlourBuilder
        self.recipeBuilder.removeFlour(flourBuilder: flourBuilder)
    }
    
    override func isReady() -> Bool {
        return self.recipeBuilder.isFlourReady()
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        guard isReady() else {
            let alert = AlertViewHelper.createErrorAlert(title: "Error",
                                                         message: errorMessage,
                                                         completion: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "MoveToRestOfIngredientsSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToRestOfIngredientsSegue" {
            let vc = segue.destination as! AddNonFlourViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
}
