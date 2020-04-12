//
//  CreateRecipeViewController.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let createNewCollectionTitle = "Create New"
fileprivate let newCollectionNameRowId = "newCollectionNameRowId"
fileprivate let collectionPickerRowId = "collectionPickerRowId"
fileprivate let percentOrWeightSwitcherRowId = "percentOrWeightSwitcherRowId"
fileprivate let weightSwitcherId = "weightSwitcherId"
fileprivate let weightRowId = "weightRowId"
fileprivate let containsPrefermentRowId = "containsPrefermentRowId"

fileprivate let prefermentNameRowId = "prefermentNameRowId"
fileprivate let prefermentPercentRowId = "prefermentPercentRowId"

fileprivate let errorMessage = "Please fill out the flour details and try again."

class CreateRecipeViewController: FormViewController {
    
    private let recipeCollections = Settings.shared.recipes
    private let recipePredicates = RecipePredicates.shared
    
    var recipeBuilder: RecipeBuilder!
    var editingRecipe: Bool {
        get {
            (self.navigationController as! CreateRecipeNavigationController).editingRecipe
        }
    }
    
    var originalWeight: Double?
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        
        form +++ Section("Recipe Details") { section in
            section <<< TitleRow() { row in
                row.placeholder = "Name"
                row.value = self.recipeBuilder.name
            }.onChange({ row in
                self.recipeBuilder.name = row.value
            })
            section <<< PickerInlineRow<String?>(collectionPickerRowId) { row in
                row.title = "Recipe Collection"
                row.noValueDisplayText = createNewCollectionTitle
                row.displayValueFor = { (rowValue: String??) in
                    if rowValue == nil || rowValue! == nil {
                        return createNewCollectionTitle
                    }
                    return rowValue!!
                }
                row.options = Settings.shared.recipes.map { $0.name }
                row.options.insert(nil, at: 0)
                if self.recipeBuilder.collection != nil {
                    row.value = self.recipeBuilder.collection
                }
                else {
                    row.value = row.options[1]
                }
                self.recipeBuilder.collection = row.value as? String
            }.onChange({ (row) in
                if let value = row.value {
                    self.recipeBuilder.collection = value
                }
                else {
                    let newCollectionTextRow = self.form.rowBy(tag: newCollectionNameRowId) as! TitleRow
                    if let newCollectionValue = newCollectionTextRow.value {
                        self.recipeBuilder.collection = newCollectionValue
                    }
                }
            })
            section <<< TitleRow(newCollectionNameRowId) { row in
                row.placeholder = "Collection Name"
                row.hidden = Condition.function([collectionPickerRowId], { form in
                    return !((form.rowBy(tag: collectionPickerRowId) as! PickerInlineRow<String?>).value! == nil)
                })
            }.onChange({ row in
                self.recipeBuilder.collection = row.value
            })
            
            section <<< WeightRow(weightRowId) { row in
                row.placeholder = "Default weight"
                row.value = self.recipeBuilder.defaultWeight
            }.onChange({ row in
                self.recipeBuilder.defaultWeight = row.value
            })
            section <<< SwitchRow(containsPrefermentRowId) { row in
                row.title = "Preferment?"
                row.value = self.recipeBuilder.containsPreferment
            }.onChange({ (row) in
                self.recipeBuilder.containsPreferment = row.value!
            })
        }
        
        form +++ Section("Preferment Details") { section in
            section.hidden = Condition.function([containsPrefermentRowId], { (form) -> Bool in
                let prefermentRow = form.rowBy(tag: containsPrefermentRowId) as! SwitchRow
                return prefermentRow.value ?? false == false
            })
            section <<< TitleRow(prefermentNameRowId) { row in
                row.placeholder = "Name"
                row.value = self.recipeBuilder.prefermentBuilder.name
            }.onChange({ (row) in
                let prefermentName = row.value
                self.recipeBuilder.prefermentBuilder.name = prefermentName
            })
            section <<< PercentRow(prefermentPercentRowId) { row in
                row.placeholder = "Percent of total flour"
                row.value = self.recipeBuilder.prefermentBuilder.totalFlourPercent
            }.onChange({ (row) in
                let percentOfFlour = row.value
                self.recipeBuilder.prefermentBuilder.totalFlourPercent = percentOfFlour
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.originalWeight = recipeBuilder.defaultWeight
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        guard isReady() else {
            let alert = AlertViewHelper.createErrorAlert(title: "Error", message: errorMessage, completion: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let name = recipeBuilder.name, recipePredicates.isRecipeNameTaken(name: name), !self.editingRecipe {
            let nameTakenAlert = UIAlertController(title: "Sorry, that name is taken", message: "Please choose a different recipe name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            nameTakenAlert.addAction(okAction)
            self.present(nameTakenAlert, animated: true, completion: nil)
        }
        else {
            self.handleWeightChange()
            self.performSegue(withIdentifier: "AddFlourSegue", sender: nil)
        }
    }
    
    private func handleWeightChange() {
        guard let originalWeight = originalWeight,
            let newWeight = recipeBuilder.defaultWeight,
            originalWeight != newWeight else {
                return
        }
        let multiplier = newWeight / originalWeight
        
        // Update all ingredients that are using weight
        recipeBuilder.mainDoughBuilder.ingredientBuilders
            .filter { $0.weight != nil }
            .forEach { $0.weight = $0.weight! * multiplier }
        recipeBuilder.prefermentBuilder.flourBuilders
            .filter { $0.weight != nil }
            .forEach { $0.weight = $0.weight! * multiplier }
        recipeBuilder.prefermentBuilder.ingredientBuilders
            .filter { $0.weight != nil }
            .forEach { $0.weight = $0.weight! * multiplier }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        if !recipeBuilder.isModified {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let alert = AlertViewHelper.createDismissAlert { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func isReady() -> Bool {
        return self.recipeBuilder.isReadyToAddIngredients()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddFlourSegue" {
            let vc = segue.destination as! AddFlourViewController
            vc.recipeBuilder = recipeBuilder
        }
    }

}
