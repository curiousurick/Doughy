//
//  ViewController.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let unitCountTag = "unitCountTag"
fileprivate let singleUnitWeightTag = "singleUnitWeightTag"
fileprivate let doughPercentSwitchTag = "doughPercentSwitchTag"
fileprivate let prefermentPercentSwitchTag = "prefermentPercentSwitchTag"
fileprivate let tempSwitchTag = "tempSwitchTag"

class CalculatorViewController: FormViewController {
    
    var ingredientSection: Section!
    var recipe: RecipeProtocol!
    var calculatedRecipe: CalculatedRecipeProtocol?
    
    private let settings = Settings.shared
    private let calculator = Calculator.shared
    private let weightFormatter = WeightFormatter.shared
    private let percentFormatter = PercentFormatter.shared
    private let tempFormatter = TemperatureFormatter.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadRecipe()
    }

    @IBAction func editButtonClicked(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditRecipeSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCalculatedRecipe" {
            let vc = segue.destination as! ShowCalculatedRecipeViewController
            vc.calculatedRecipe = self.calculatedRecipe
        }
        else if segue.identifier == "EditRecipeSegue" {
            let nc = segue.destination as! CreateRecipeNavigationController
            let recipeBuilder = RecipeBuilder(recipe: recipe)
            nc.recipeBuilder = recipeBuilder
        }
    }

    @IBAction func unwindToMenuFromUpdate(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! PreviewRecipeViewController
        let updatedRecipe = sourceViewController.recipe
        self.recipe = updatedRecipe
        self.title = updatedRecipe?.name
        self.reloadRecipe()
    }

    private func displayCalculationError(mixName: String, name: String, value: Double) {
        let badWeight = weightFormatter.format(weight: value)
        let message = "Calculated \(mixName) \(name) weight is \(badWeight). Please adjust input."
        let alert = UIAlertController(title: "Calculation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func reloadRecipe() {
        self.form.removeAll()
        form +++ Section(recipe.name) { section in
            section <<< IntRow(unitCountTag) { row in
                row.title = "Number of Doughs"
                row.placeholder = "Default: 1"
            }.onCellHighlightChanged({ (cell, row) in
                self.moveCursorToEnd(textField: cell.textField)
            })
            section <<< WeightRow(singleUnitWeightTag) { row in
                row.title = "Single Dough Weight"
                row.placeholder = self.weightFormatter.format(weight: self.recipe.defaultWeight)
            }.onCellHighlightChanged({ (cell, row) in
                self.moveCursorToEnd(textField: cell.textField)
            })
            section <<< SwitchRow(prefermentPercentSwitchTag) { row in
                row.title = "Adjust Preferment Ingredients"
                row.value = false
                row.hidden = Condition(booleanLiteral: self.recipe is Recipe)
            }
            
            section <<< SwitchRow(doughPercentSwitchTag) { row in
                row.title = "Adjust Dough Ingredients"
                row.value = false
            }
            section <<< SwitchRow(tempSwitchTag) { row in
                row.title = "Adjust Ingredient Temperatures"
                row.value = false
                row.hidden = Condition(booleanLiteral: !self.recipe.containsVariableTemps())
            }
        }
        if self.recipe is PrefermentRecipe {
            let preferment = (self.recipe as! PrefermentRecipe).preferment
            form +++ Section("Preferment") { section in
                
                section.hidden = Condition.function([prefermentPercentSwitchTag], { (form) -> Bool in
                    return !(form.rowBy(tag: prefermentPercentSwitchTag) as! SwitchRow).value!
                })
                section <<< PercentRow("preferment_total_scalable.\(preferment.name)") { row in
                    row.title = "\(preferment.name) Flour Of Total"
                    let defaultPercent = preferment.flourPercentage
                    let placeholderPercent = self.percentFormatter.format(percent: defaultPercent)
                    row.placeholder = "Default: \(placeholderPercent)"
                }.onCellHighlightChanged({ (cell, row) in
                    self.moveCursorToEnd(textField: cell.textField)
                })
                let ingredients = preferment.ingredients
                for index in 0..<ingredients.count {
                    let ingredient = ingredients[index]
                    section <<< PercentRow("preferment_scalable.\(index)") { row in
                        row.title = "\(ingredient.name)"
                        let defaultPercent = ingredient.defaultPercentage
                        let placeholderPercent = self.percentFormatter.format(percent: defaultPercent)
                        if ingredient.isFlour {
                            row.disabled = Condition(booleanLiteral: true)
                            row.placeholder = "\(placeholderPercent)"
                        }
                        else {
                            row.placeholder = "Default: \(placeholderPercent)"
                        }
                    }
                }
            }
        }
        
        form +++ Section("Ingredients") { section in
            section.hidden = Condition.function([doughPercentSwitchTag], { (form) -> Bool in
                return !(form.rowBy(tag: doughPercentSwitchTag) as! SwitchRow).value!
            })
            let ingredients = self.recipe.ingredients
            for index in 0..<ingredients.count {
                let ingredient = ingredients[index]
                section <<< PercentRow("scalable.\(index)") { row in
                    row.title = "\(ingredient.name)"
                    let defaultPercent = ingredient.defaultPercentage
                    let placeholderPercent = self.percentFormatter.format(percent: defaultPercent)
                    if ingredient.isFlour {
                        row.disabled = Condition(booleanLiteral: true)
                        row.placeholder = "\(placeholderPercent)"
                    }
                    else {
                        row.placeholder = "Default: \(placeholderPercent)"
                    }
                }.onCellHighlightChanged({ (cell, row) in
                    self.moveCursorToEnd(textField: cell.textField)
                })
            }
        }
        
        form +++ Section("Temperatures") { section in
            section.hidden = Condition.function([tempSwitchTag], { (form) -> Bool in
                return !(form.rowBy(tag: tempSwitchTag) as! SwitchRow).value!
            })
            if self.recipe is PrefermentRecipe {
                let preferment = (self.recipe as! PrefermentRecipe).preferment
                let prefermentIngredients = preferment.ingredients
                for index in 0..<prefermentIngredients.count {
                    let ingredient = prefermentIngredients[index]
                    if let temp = ingredient.temperature {
                        section <<< TemperatureRow("preferment_temps.\(index)") { row in
                            row.title = "\(preferment.name) \(ingredient.name)"
                            row.placeholder = self.tempFormatter.format(temperature: temp)
                            row.measurement = self.settings.preferredTemp()
                        }.onCellHighlightChanged({ (cell, row) in
                            self.moveCursorToEnd(textField: cell.textField)
                        })
                    }
                }
            }
            let ingredients = self.recipe.ingredients
            for index in 0..<ingredients.count {
                let ingredient = ingredients[index]
                if let temp = ingredient.temperature {
                    section <<< TemperatureRow("temps.\(index)") { row in
                        row.title = "\(ingredient.name)"
                        row.placeholder = self.tempFormatter.format(temperature: temp)
                        row.measurement = self.settings.preferredTemp()
                    }.onCellHighlightChanged({ (cell, row) in
                        self.moveCursorToEnd(textField: cell.textField)
                    })
                }
            }
        }
        form +++ Section("Calculate") { section in
            section <<< ButtonRow("CalculateButtonTag") {
                $0.title = "How much do I need?"
            }.onCellSelection({ (cell, buttonRow) in
                self.updateIngredients()
            })
        }
    }
    
    func updateIngredients() {
        let doughCount = (form.rowBy(tag: unitCountTag) as! IntRow).value ?? 1
        let defaultWeight = recipe.defaultWeight
        let singleDoughWeight = (form.rowBy(tag: singleUnitWeightTag) as! WeightRow).value ?? defaultWeight
        let totalWeight = singleDoughWeight * Double(doughCount)
        
        var measuredIngredients = [MeasuredIngredient]()
        let ingredients = recipe.ingredients
        for index in 0..<ingredients.count {
            let ingredient = ingredients[index]
            let row = form.rowBy(tag: "scalable.\(index)") as! PercentRow
            let percent = row.value ?? ingredient.defaultPercentage
            let tempRow = form.rowBy(tag: "temps.\(index)") as? TemperatureRow
            var temperature: Temperature? = ingredient.temperature
            if let tempValue = tempRow?.value {
                temperature = Temperature(value: tempValue, measurement: settings.preferredTemp())
            }
            measuredIngredients.append(MeasuredIngredient(ingredient: ingredient, percent: percent, temperature: temperature))
        }
        var measuredPreferment: MeasuredPreferment?
        if recipe is PrefermentRecipe {
            let preferment = (recipe as! PrefermentRecipe).preferment
            var measuredFermentIngredients = [MeasuredIngredient]()
            let fermentIngredients = preferment.ingredients
            for index in 0..<fermentIngredients.count {
                let ingredient = fermentIngredients[index]
                let row = form.rowBy(tag: "preferment_scalable.\(index)") as! PercentRow
                let percent = row.value ?? ingredient.defaultPercentage
                let tempRow = form.rowBy(tag: "preferment_temps.\(index)") as? TemperatureRow
                var temperature: Temperature? = ingredient.temperature
                if let tempValue = tempRow?.value {
                    temperature = Temperature(value: tempValue, measurement: settings.preferredTemp())
                }
                measuredFermentIngredients.append(MeasuredIngredient(ingredient: ingredient, percent: percent, temperature: temperature))
            }
            let fermentPercent = (form.rowBy(tag: "preferment_total_scalable.\(preferment.name)") as! PercentRow).value ?? preferment.flourPercentage
            measuredPreferment = MeasuredPreferment(ingredients: measuredFermentIngredients,
                                                    name: preferment.name,
                                                    flourPercentage: fermentPercent)
        }
        
        do {
            try self.calculatedRecipe = self.calculator.calculate(
                ingredients: measuredIngredients,
                preferment: measuredPreferment,
                recipe: recipe,
                totalWeight: totalWeight)
        }
        catch CalculationError.finalDoughNegativeValue(let name, let value) {
            self.displayCalculationError(mixName: "Final Dough", name: name, value: value)
            return
        }
        catch CalculationError.prefermentNegativeValue(let name, let value) {
            self.displayCalculationError(mixName: "Preferment", name: name, value: value)
            return
        }
        catch { fatalError("Unexpected Error thrown by calculator") }
        
        self.performSegue(withIdentifier: "ShowCalculatedRecipe", sender: nil)
    }
    
    private func moveCursorToEnd(textField: UITextField) {
        if textField.isFirstResponder {
            let end = textField.endOfDocument
            let textRange = textField.textRange(from: end, to: end)
            DispatchQueue.main.async {
                textField.selectedTextRange = textRange
            }
        }
    }
}

