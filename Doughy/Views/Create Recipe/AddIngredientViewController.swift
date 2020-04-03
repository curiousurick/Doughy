//
//  AddFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class AddIngredientViewController: FormViewController {
    
    var recipeBuilder: RecipeBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = getTitle()
        
        initializeBuilders()
        
        form +++ Section() { section in
            section <<< ButtonRow() { row in
                row.title = "Add another ingredient"
            }.onCellSelection({ (cell, row) in
                self.form +++ self.createIngredientSection(builder: nil)
                self.toggleNextButton()
            })
        }
        
        let ingredientBuilders = self.getBuilders()
        
        if ingredientBuilders.isEmpty {
            form +++ createIngredientSection(builder: nil)
        }
        else {
            ingredientBuilders.forEach {
                self.form +++ self.createIngredientSection(builder: $0)
            }
            self.toggleNextButton()
        }
    }
    
    func createIngredientSection(builder: IngredientBuilderBase?) -> AddIngredientSection {
        let newBuilder = builder == nil ? self.addBuilder() : builder!
        
        return AddIngredientSection(builder: newBuilder, recipeBuilder: self.recipeBuilder) { section in
            let section = section as! AddIngredientSection
            section <<< NameRow() { row in
                row.placeholder = "Name"
                row.value = newBuilder.name
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection
                section.builder.name = row.value
                self.toggleNextButton()
            })
            section <<< self.createPercentRow(builder: newBuilder)
            section <<< TemperatureRow() { row in
                row.placeholder = "Temperature (not required)"
                row.value = newBuilder.temperature
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection
                section.builder.temperature = row.value
                self.toggleNextButton()
            })
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
            if self is AddNonFlourViewController {
                section <<< ButtonRow() { row in
                    row.title = "Use weight"
                }.onCellSelection({ (cell, row) in
                    var section = row.section as! AddIngredientSection
                    self.toggleIngredientMode(section: &section)
                })
            }
            section <<< ButtonRow() { row in
                row.title = "Delete"
            }.cellSetup({ (cell, row) in
                cell.tintColor = .systemRed
            }).onCellSelection({ (cell, row) in
                let section = row.section as! AddIngredientSection
                self.removeBuilder(builder: section.builder)
                self.form.removeAll { $0 == section }
                self.toggleNextButton()
            })
        }
    }
    
    func createPercentRow(builder: IngredientBuilderBase) -> PercentRow {
        PercentRow() { row in
            row.placeholder = "Percent (of total flour)"
            row.value = builder.percent
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection
            section.builder.percent = row.value
            self.toggleNextButton()
        })
    }
    
    func createWeightRow(builder: IngredientBuilder) -> WeightRow {
        WeightRow() { row in
            let weight = WeightFormatter.shared.format(weight: NSNumber(floatLiteral: recipeBuilder.defaultWeight!))
            row.placeholder = "Weight (in grams) for \(weight) dough"
            row.value = builder.weight
        }.onChange({ (row) in
            let section = row.section as! AddIngredientSection
            let builder = section.builder as! IngredientBuilder
            builder.weight = row.value
            self.toggleNextButton()
        })
    }
    
    func toggleIngredientMode(section: inout AddIngredientSection) {
        let newRow: BaseRow
        let switchModeRow = section.allRows[3] as! ButtonRow
        let builder = section.builder as! IngredientBuilder
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
    
    func initializeBuilders() {
        fatalError("not implemented")
    }
    
    func getTitle() -> String {
        fatalError("not implemented")
    }
    
    func getBuilders() -> [IngredientBuilderBase] {
        fatalError("not implemented")
    }
    
    func addBuilder() -> IngredientBuilderBase {
        fatalError("not implemented")
    }
    
    func removeBuilder(builder: IngredientBuilderBase) {
        fatalError("not implemented")
    }
    
    func toggleNextButton() {
        fatalError("not implemented")
    }

}

class AddIngredientSection: Section {
    
    var recipeBuilder: RecipeBuilder!
    var builder: IngredientBuilderBase!
    
    init(builder: IngredientBuilderBase, recipeBuilder: RecipeBuilder, _ initializer: @escaping (Section) -> Void) {
        self.builder = builder
        self.recipeBuilder = recipeBuilder
        super.init(initializer)
    }
    
    required init<S>(_ elements: S) where S : Sequence, S.Element == BaseRow {
        super.init(elements)
    }
    
    required init() {
        super.init()
    }
}
