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
        
        let ingredientBuilders = self.getBuilders()?.builders
        
        if ingredientBuilders?.isEmpty ?? true {
            form +++ createIngredientSection(builder: nil)
        }
        else {
            ingredientBuilders!.forEach {
                self.form +++ self.createIngredientSection(builder: $0)
            }
            self.toggleNextButton()
        }
    }
    
    func createIngredientSection(builder: IngredientBuilder?) -> AddIngredientSection {
        let newBuilder = builder == nil ? self.addBuilder() : builder!
        
        return AddIngredientSection(builder: newBuilder) { section in
            section <<< NameRow() { row in
                row.placeholder = "Name"
                row.value = newBuilder.name
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection
                section.builder.name = row.value
                self.toggleNextButton()
            })
            section <<< PercentRow() { row in
                row.placeholder = "Percent (of total flour)"
                row.value = newBuilder.percent
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection
                section.builder.percent = row.value
                self.toggleNextButton()
            })
            section <<< TemperatureRow() { row in
                row.placeholder = "Temperature (not required)"
                row.value = newBuilder.temperature
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection
                section.builder.temperature = row.value
                self.toggleNextButton()
            })
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
    
    func initializeBuilders() {
        fatalError("not implemented")
    }
    
    func getTitle() -> String {
        fatalError("not implemented")
    }
    
    func getBuilders() -> IngredientsBuilder? {
        fatalError("not implemented")
    }
    
    func addBuilder() -> IngredientBuilder {
        fatalError("not implemented")
    }
    
    func removeBuilder(builder: IngredientBuilder) {
        fatalError("not implemented")
    }
    
    func toggleNextButton() {
        fatalError("not implemented")
    }

}

class AddIngredientSection: Section {
    
    var builder: IngredientBuilder!
    
    init(builder: IngredientBuilder, _ initializer: @escaping (Section) -> Void) {
        self.builder = builder
        super.init(initializer)
    }
    
    required init<S>(_ elements: S) where S : Sequence, S.Element == BaseRow {
        super.init(elements)
    }
    
    required init() {
        super.init()
    }
    
}
