//
//  AddInstructionsViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class AddInstructionsViewController: FormViewController {
    
    private let objectFactory = ObjectFactory.shared
    private let calculator = Calculator.shared
    private let percentFormatter = PercentFormatter.shared
    
    var recipeBuilder: RecipeBuilder!
    
    var recipe: RecipeProtocol?
    var calculatedRecipe: CalculatedRecipeProtocol?

    @IBOutlet weak var previewButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isEditing = true
        
        form +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Add Instructions") { section in
            section.showInsertIconInAddButton = false
            section.addButtonProvider = { section in
                return ButtonRow() {
                    $0.title = "Add New Step"
                }
            }
            section.multivaluedRowToInsertAt = { index in
                return self.createTextAreaRow(instruction: nil)
            }
            if let instructions = recipeBuilder.instructions {
                instructions.forEach {
                    section <<< createTextAreaRow(instruction: $0)
                }
            }
            else {
                section <<< createTextAreaRow(instruction: nil)
            }
        }
    }
    
    private func createTextAreaRow(instruction: Instruction?) -> TextAreaRow {
        return TextAreaRow() {
            $0.placeholder = "Add details"
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 20)
            $0.value = instruction?.step
        }
    }
    
    @IBAction func previewButtonClicked(button: UIBarButtonItem) {
        var instructions = [Instruction]()
        let textRows = form.rows.filter { $0 is TextAreaRow } as! [TextAreaRow]
        for row in textRows {
            let instruction = Instruction(step: row.value ?? "")
            instructions.append(instruction)
        }

        recipeBuilder.instructions = instructions
        
        do {
            self.recipe = try recipeBuilder.build()
            self.calculatedRecipe = try calculator.calculate(recipe: recipe!)
        }
        catch where error is RecipeBuilderError {
            let recipeError = error as! RecipeBuilderError
            let message = getMessageForError(error: recipeError)
            let title = "Error creating recipe"
            let alert = AlertViewHelper.createErrorAlert(title: title, message: message, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        catch where error is CalculationError {
            print(error)
            fatalError("Error calculating recipe should never happen in recipe creation")
        }
        catch {
            fatalError("Unexpected error")
        }
        
        self.performSegue(withIdentifier: "PreviewRecipeSegue", sender: button)
    }
    
    private func getMessageForError(error: RecipeBuilderError) -> String {
        switch error {
        case .invalidIngredients:
            return "Please go back and fix the recipe"
        case .missingCollection:
            return "Please go back and add the collection for this recipe."
        case .missingName:
            return "Please go back and add the name for this recipe."
        case .missingDefaultWeight:
            return "Please go back and add a default weight for this recipe."
        case .missingInstructions:
            return "Please go back and add instructions for this recipe."
        case .mainDoughMissingPreferment(let ingredient):
            return "Preferment contains \(ingredient.name) which is not included in the final dough"
        case .mainDoughLessThanPreferment(let mainDough, let prefermentIngredient):
            let prefermentPercent = percentFormatter.format(percent: prefermentIngredient.defaultPercentage)
            let mainDoughPercent = percentFormatter.format(percent: mainDough.defaultPercentage)
            let name = mainDough.name
            return "Preferment contains \(prefermentPercent) \(name) and final dough has \(mainDoughPercent)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewRecipeSegue" {
            let vc = segue.destination as! PreviewRecipeViewController
            vc.calculatedRecipe = self.calculatedRecipe
            vc.recipe = self.recipe
            vc.recipeBuilder = self.recipeBuilder
        }
    }
}
