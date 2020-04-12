//
//  AddFlourViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class AddIngredientViewController<T>: FormViewController where T: IngredientBuilderBase {
    
    let settings = Settings.shared
    
    var percentRowTitle: String {
        get { fatalError("not implemented") }
    }
    var addAnotherIngredientTitle: String {
        get { fatalError("not implemented") }
    }
    var viewTitle: String {
        get { fatalError("not implemented") }
    }
    
    var recipeBuilder: RecipeBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.title = viewTitle
        
        initializeBuilders()
        
        form +++ Section() { section in
            section <<< ButtonRow() { row in
                row.title = self.addAnotherIngredientTitle
            }.onCellSelection({ (cell, row) in
                self.form +++ self.createIngredientSection(builder: nil)
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
        }
    }
    
    func createIngredientSection(builder: T?) -> AddIngredientSection<T> {
        let newBuilder = builder == nil ? self.addBuilder() : builder!
        
        return AddIngredientSection<T>(builder: newBuilder, recipeBuilder: self.recipeBuilder) { section in
            var section = section as! AddIngredientSection<T>
            if self.shouldAddTitleRow() {
                section <<< TitleRow() { row in
                    row.placeholder = "Name"
                    row.value = newBuilder.name
                }.onChange({ (row) in
                    let section = row.section as! AddIngredientSection<T>
                    section.builder.name = row.value
                })
            }
            self.addAmountRow(section: &section)
            section <<< TemperatureRow() { row in
                row.placeholder = "Temperature (not required)"
                row.value = newBuilder.temperature?.value
                row.measurement = self.settings.preferredTemp()
            }.onChange({ (row) in
                let section = row.section as! AddIngredientSection<T>
                if let temp = row.value {
                    section.builder.temperature = Temperature(value: temp, measurement: self.settings.preferredTemp())
                }
                else {
                    section.builder.temperature = nil
                }
            })
            self.addOptionalRows(section: &section)
            
            section <<< ButtonRow() { row in
                row.title = "Delete"
            }.cellSetup({ (cell, row) in
                cell.tintColor = .systemRed
            }).onCellSelection({ (cell, row) in
                let section = row.section as! AddIngredientSection<T>
                self.removeBuilder(builder: section.builder)
                self.form.removeAll { $0 == section }
            })
        }
    }
    
    func addOptionalRows(section: inout AddIngredientSection<T>) {
        // Do nothing
    }
    
    func addAmountRow(section: inout AddIngredientSection<T>) {
        fatalError()
    }
    
    func shouldAddTitleRow() -> Bool {
        return true
    }
    
    func initializeBuilders() {
        fatalError("not implemented")
    }
    
    func getBuilders() -> [T] {
        fatalError("not implemented")
    }
    
    func addBuilder() -> T {
        fatalError("not implemented")
    }
    
    func removeBuilder(builder: T) {
        fatalError("not implemented")
    }
    
    func isReady() -> Bool {
        fatalError("not implemented")
    }

}

class AddIngredientSection<T>: Section where T: IngredientBuilderBase {
    
    var recipeBuilder: RecipeBuilder!
    var builder: T!
    
    init(builder: T, recipeBuilder: RecipeBuilder, _ initializer: @escaping (Section) -> Void) {
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
