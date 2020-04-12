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

class AddFlourViewController: AddIngredientViewController<FlourBuilder> {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override var percentRowTitle: String {
        get { return "Percent (of total flour)" }
    }
    override var addAnotherIngredientTitle: String {
        get { return "Add another flour" }
    }
    
    override var viewTitle: String {
        get {
            return "Add Flour"
        }
    }
    
    override func initializeBuilders() {
        //  recipeBuilder.prepareForTransitionToMainDough()
        if recipeBuilder.mainDoughBuilder.flourBuilders.isEmpty {
            recipeBuilder.addFlour(flourBuilder: FlourBuilder())
        }
    }
    
    override func getBuilders() -> [FlourBuilder] {
        return recipeBuilder.mainDoughBuilder.flourBuilders
    }
    
    override func addBuilder() -> FlourBuilder {
        recipeBuilder.addFlour(flourBuilder: FlourBuilder())
        return recipeBuilder.mainDoughBuilder.flourBuilders.last!
    }
    
    override func removeBuilder(builder: FlourBuilder) {
        self.recipeBuilder.removeFlour(flourBuilder: builder)
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
        self.performSegue(withIdentifier: "AddRemainingIngredientsSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRemainingIngredientsSegue" {
            let vc = segue.destination as! AddNonFlourViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
    override func addAmountRow(section: inout AddIngredientSection<FlourBuilder>) {
        let builder = section.builder!
        section <<< PercentRow() { row in
            row.placeholder = percentRowTitle
            row.value = builder.percent
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection<FlourBuilder>
            section.builder.percent = row.value
        })
    }
}
