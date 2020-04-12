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

class AddNonFlourViewController: AddIngredientViewController<IngredientBuilder> {
    
    override var percentRowTitle: String {
        get { return "Percent (compared to total flour)" }
    }
    override var addAnotherIngredientTitle: String {
        get { return "Add another ingredient" }
    }
    
    override var viewTitle: String {
        get {
            return "Add Remaining Ingredients"
        }
    }
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func initializeBuilders() {
        if recipeBuilder.mainDoughBuilder.ingredientBuilders.isEmpty {
            recipeBuilder.addIngredient(ingredientBuilder: IngredientBuilder())
        }
    }
    
    override func getBuilders() -> [IngredientBuilder] {
        return recipeBuilder.mainDoughBuilder.ingredientBuilders
    }
    
    override func addBuilder() -> IngredientBuilder {
        recipeBuilder.addIngredient(ingredientBuilder: IngredientBuilder())
        return recipeBuilder.mainDoughBuilder.ingredientBuilders.last!
    }
    
    override func removeBuilder(builder: IngredientBuilder) {
        self.recipeBuilder.removeIngredient(ingredientBuilder: builder)
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
        if recipeBuilder.containsPreferment {
            self.performSegue(withIdentifier: "AddPrefermentSegue", sender: sender)
        }
        else {
            self.performSegue(withIdentifier: "AddInstructionsSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddInstructionsSegue" {
            let vc = segue.destination as! AddInstructionsViewController
            vc.recipeBuilder = recipeBuilder
        }
        if segue.identifier == "AddPrefermentSegue" {
            let vc = segue.destination as! SetPrefermentViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
    
    override func addAmountRow(section: inout AddIngredientSection<IngredientBuilder>) {
        let builder = section.builder!
        if section.builder.weight != nil {
            section <<< createWeightRow(builder: builder)
        }
        else {
            section <<< createPercentRow(builder: builder)
        }
    }
    
    override func addOptionalRows(section: inout AddIngredientSection<IngredientBuilder>) {
        // Only allow switching to weight for non flour.
        // It's mathematically impossible to calculate
        // If you choose a weight for flour because
        // The % is based on total flour being the base 100%
        // When x% of flour is a specific weight, it means you
        // have decided that 100% is either a specific weight or
        // that 100% is a specific ratio of the total cumulative %.
        // You have to decide which one to use to make the final calculation
        // for all the other ingredients. Which means you can't trust
        // the weight chosen for the flour.
        section <<< ButtonRow() { row in
            row.title = "Use weight"
        }.onCellSelection({ (cell, row) in
            var section = row.section as! AddIngredientSection<IngredientBuilder>
            self.toggleIngredientMode(section: &section)
        })
    }
    
    func toggleIngredientMode(section: inout AddIngredientSection<IngredientBuilder>) {
        let newRow: BaseRow
        let switchModeRow = section.allRows[3] as! ButtonRow
        let builder = section.builder!
        if builder.mode == .percent {
            builder.mode = .weight
            builder.percent = nil
            newRow = createWeightRow(builder: builder)
            switchModeRow.title = "Use percent"
        }
        else {
            builder.mode = .percent
            builder.weight = nil
            newRow = createPercentRow(builder: builder)
            switchModeRow.title = "Use weight"
        }
        section.remove(at: 1)
        section.insert(newRow, at: 1)
        switchModeRow.reload()
    }
    
    func createWeightRow(builder: IngredientBuilder) -> WeightRow {
        WeightRow() { row in
            let weight = WeightFormatter.shared.format(weight: recipeBuilder.defaultWeight!)
            row.placeholder = "Weight (in grams) for \(weight) dough"
            row.value = builder.weight
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection<IngredientBuilder>
            section.builder?.weight = row.value
        })
    }
    
    func createPercentRow(builder: IngredientBuilder) -> PercentRow {
        return PercentRow() { row in
            row.placeholder = percentRowTitle
            row.value = builder.percent
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection<IngredientBuilder>
            section.builder.percent = row.value
        })
    }
    
}
