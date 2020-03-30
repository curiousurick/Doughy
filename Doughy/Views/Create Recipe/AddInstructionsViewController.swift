//
//  AddInstructionsViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let errorMessageMap = [
    RecipeBuilderError.invalidIngredients : "Please go back and fix the recipe ingredients.",
    RecipeBuilderError.missingCollection : "Please go back and add the collection for this recipe.",
    RecipeBuilderError.missingName : "Please go back and add the name for this recipe.",
    RecipeBuilderError.missingDefaultWeight : "Please go back and add a default weight for this recipe.",
    RecipeBuilderError.missingInstructions : "Please go back and add instructions for this recipe."
]

class AddInstructionsViewController: FormViewController {
    
    private let objectFactory = ObjectFactory.shared
    private let calculator = Calculator.shared
    
    var recipeBuilder: RecipeBuilder!
    
    var recipe: Recipe?
    var calculatedRecipe: CalculatedRecipe?

    @IBOutlet weak var previewButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set to false so delete button is not visible
        self.tableView.isEditing = false
    }
    
    @IBAction func previewButtonClicked(button: UIBarButtonItem) {
        var instructions = [Instruction]()
        let textRows = form.rows.filter { $0 is TextAreaRow } as! [TextAreaRow]
        for row in textRows {
            let instruction = objectFactory.createInstruction(step: row.value ?? "")
            instructions.append(instruction)
        }

        recipeBuilder.instructions = instructions
        
        do {
            self.recipe = try recipeBuilder.build()
            self.calculatedRecipe = try calculator.calculate(recipe: recipe!)
        }
        catch where error is RecipeBuilderError {
            let recipeError = error as! RecipeBuilderError
            let message = errorMessageMap[recipeError]!
            let title = "Error creating recipe"
            self.showErrorMessage(title: title, message: message)
        }
        catch where error is CalculationError {
            fatalError("Error calculating recipe should never happen in recipe creation")
        }
        catch {
            fatalError("Unexpected error")
        }
        
        self.performSegue(withIdentifier: "PreviewRecipeSegue", sender: button)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewRecipeSegue" {
            let vc = segue.destination as! PreviewRecipeViewController
            vc.calculatedRecipe = self.calculatedRecipe
            vc.recipe = self.recipe
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
