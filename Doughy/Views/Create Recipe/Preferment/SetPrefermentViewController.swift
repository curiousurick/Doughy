//
//  SetPrefermentViewController.swift
//  Doughy
//
//  Created by urickg on 4/5/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let prefermentNameRowId = "prefermentNameRowId"
fileprivate let prefermentPercentRowId = "prefermentPercentRowId"

fileprivate let ingredientSliderSectionId = "ingredientSliderSectionId"
fileprivate let addIngredientSliderButtonId = "addIngredientSliderButtonId"

class SetPrefermentViewController: AddIngredientViewController<PrefermentIngredientBuilder> {
    
    private let weightFormatter = WeightFormatter.shared
    
    override var percentRowTitle: String {
        get { return "Percent (of preferment flour)" }
    }
    
    override var addAnotherIngredientTitle: String {
        get { return "Add another ingredient" }
    }
    
    override var viewTitle: String {
        get { return "Add Preferment Ingredients" }
    }
    

    override func setupView() {
        self.title = viewTitle

        form +++ Section("Preferment Details") { section in
            section <<< TitleRow(prefermentNameRowId) { row in
                row.title = "Name"
                row.value = self.recipeBuilder.prefermentBuilder.name
                row.disabled = Condition(booleanLiteral: true)
            }.onChange({ (row) in
                let prefermentName = row.value
                self.recipeBuilder.prefermentBuilder.name = prefermentName
            })
            section <<< PercentRow(prefermentPercentRowId) { row in
                row.title = "Percent of total flour"
                row.value = self.recipeBuilder.prefermentBuilder.totalFlourPercent
                row.disabled = Condition(booleanLiteral: true)
            }.onCellHighlightChanged({ (cell, row) in
            }).onChange({ (row) in
                let percentOfFlour = row.value
                self.recipeBuilder.prefermentBuilder.totalFlourPercent = percentOfFlour
            })
        }

        form +++ Section() { section in
            section <<< ActionSheetRow<IngredientBuilderBase>(addIngredientSliderButtonId) { row in
                row.title = self.addAnotherIngredientTitle
                row.selectorTitle = "Choose from existing ingredients or add a new one"
                row.options = self.getUnusedBuilders()
                row.displayValueFor = { (rowValue: IngredientBuilderBase?) in
                    return rowValue?.name
                }
            }.onChange({ (row) in
                guard let value = row.value else {
                    return
                }
                let prefermentBuilder = self.createPrefermentCopy(builder: value)
                self.recipeBuilder.addPrefermentIngredient(ingredientBuilder: prefermentBuilder)
                self.form +++ self.createIngredientSection(builder: prefermentBuilder)
                row.options = self.getUnusedBuilders()
                row.value = nil
            })
        }
        
        self.recipeBuilder.prefermentBuilder.flourBuilders.forEach {
            self.form +++ self.createIngredientSection(builder: $0)
        }
        
        self.recipeBuilder.prefermentBuilder.ingredientBuilders.forEach {
            self.form +++ self.createIngredientSection(builder: $0)
        }
    }
    
    private func getUnusedBuilders() -> [IngredientBuilderBase] {
        var options: [IngredientBuilderBase] = []
        options.append(contentsOf: self.recipeBuilder.mainDoughBuilder.flourBuilders)
        options.append(contentsOf: self.recipeBuilder.mainDoughBuilder.ingredientBuilders)
        
        // Don't let them add ingredients they've already added.
        options.removeAll(where: { option in
            self.recipeBuilder.prefermentBuilder.flourBuilders
                .contains { $0.name == option.name }
                || self.recipeBuilder.prefermentBuilder.ingredientBuilders
                    .contains { $0.name == option.name }
        })
        return options
    }
    
    private func createPrefermentCopy(builder: IngredientBuilderBase) -> PrefermentIngredientBuilder {
        let prefBuilder = PrefermentIngredientBuilder(isFlour: builder is FlourBuilder)
        prefBuilder.name = builder.name
        return prefBuilder
    }

    override func addBuilder() -> PrefermentIngredientBuilder {
        recipeBuilder.addPrefermentIngredient(ingredientBuilder: PrefermentIngredientBuilder(isFlour: false))
        return recipeBuilder.prefermentBuilder.ingredientBuilders.last!
    }

    override func removeBuilder(builder: PrefermentIngredientBuilder) {
        self.recipeBuilder.removePrefermentIngredient(ingredientBuilder: builder)
    }
    
    func createWeightSliderRow(builder: PrefermentIngredientBuilder) -> WeightSliderRow {
        let maxWeight: Double
        var minWeight: Double = 0.0
        if builder.isFlour {
            let maxIngredientWeight = self.recipeBuilder.mainDoughBuilder.flourBuilders.first {
                $0.name == builder.name
            }.map { self.recipeBuilder.calculateWeight(flourBuilder: $0) }!
            let totalFlourWeight = self.recipeBuilder.calculateDefaultFlourWeight()
            let flourPercent = self.recipeBuilder.prefermentBuilder.totalFlourPercent! / 100
            let maxFlourWeight = flourPercent * totalFlourWeight
            maxWeight = min(maxIngredientWeight, maxFlourWeight)
            if self.recipeBuilder.mainDoughBuilder.flourBuilders.count == 1 {
                minWeight = maxWeight
                
            }
        }
        else {
            maxWeight = self.recipeBuilder.mainDoughBuilder.ingredientBuilders.first {
                $0.name == builder.name
            }.map { self.recipeBuilder.calculateWeight(ingredientBuilder: $0) }!
        }
        
        return WeightSliderRow() { row in
            row.title = builder.name
            
            row.useFormatterDuringInput = false
            row.useFormatterOnDidBeginEditing = true
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            formatter.minimum = 0
            row.formatter = formatter
            
            row.validationOptions = .validatesOnChange
            var ruleSet = RuleSet<Double>()
            let formattedMin = self.weightFormatter.format(weight: minWeight)
            ruleSet.add(rule: RuleGreaterOrEqualThan(min: minWeight, msg: "\(builder.name!) must be greater than \(formattedMin) grams", id: nil))
            let formattedMax = self.weightFormatter.format(weight: maxWeight)
            ruleSet.add(rule: RuleSmallerOrEqualThan(max: maxWeight, msg: "\(builder.name!) must be less than \(formattedMax) grams"))
            row.add(ruleSet: ruleSet)
            
            let defaultValue: Double
            if minWeight == maxWeight {
                defaultValue = minWeight
                row.disabled = Condition.init(booleanLiteral: true)
            }
            else {
                defaultValue = 0
            }
            
            // set if not already set
            builder.weight = builder.weight ?? defaultValue
            row.value = builder.weight
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection<PrefermentIngredientBuilder>
            let builder = section.builder
            builder?.weight = row.value
        }).onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                let labelRow = LabelRow() {
                    $0.title = row.validationErrors[0].msg
                    $0.cell.height = { 30 }
                }.cellUpdate { (cell, row) in
                    cell.contentView.backgroundColor = .red
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    cell.textLabel?.textAlignment = .left
                }
                let indexPath = row.indexPath!.row + 1
                row.section?.insert(labelRow, at: indexPath)
            }
        }
    }
    
    override func addAmountRow(section: inout AddIngredientSection<PrefermentIngredientBuilder>) {
        section <<< self.createWeightSliderRow(builder: section.builder)
    }
    
    override func shouldAddTitleRow() -> Bool {
        return false
    }

    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        if !self.recipeBuilder.prefermentBuilder.isReady() {
            let alert = AlertViewHelper.createErrorAlert(title: "Not ready", message: "Please fill out the preferment details before you continue", completion: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "AddInstructionsFromPrefermentSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddInstructionsFromPrefermentSegue" {
            let vc = segue.destination as! AddInstructionsViewController
            vc.recipeBuilder = recipeBuilder
        }
    }
}
