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


class CreateRecipeViewController: FormViewController {
    
    private let recipeCollections = Settings.shared.recipes
    private let recipePredicates = RecipePredicates.shared
    
    var recipeBuilder: RecipeBuilder!
    var editingRecipe: Bool {
        get {
            (self.navigationController as! CreateRecipeNavigationController).editingRecipe
        }
    }
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Details"
        
        form +++ Section("Recipe Details") { section in
            section <<< NameRow() { row in
                row.placeholder = "Name"
                row.value = self.recipeBuilder.name
                row.disabled = Condition(booleanLiteral: row.value != nil)
            }.onChange({ row in
                self.recipeBuilder.name = row.value
                self.toggleNextButton()
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
                self.toggleNextButton()
                
            }.onChange({ (row) in
                if let value = row.value {
                    self.recipeBuilder.collection = value
                }
                else {
                    let newCollectionTextRow = self.form.rowBy(tag: newCollectionNameRowId) as! NameRow
                    if let newCollectionValue = newCollectionTextRow.value {
                        self.recipeBuilder.collection = newCollectionValue
                    }
                }
                self.toggleNextButton()
            })
            section <<< NameRow(newCollectionNameRowId) { row in
                row.placeholder = "Collection Name"
                row.hidden = Condition.function([collectionPickerRowId], { form in
                    return !((form.rowBy(tag: collectionPickerRowId) as! PickerInlineRow<String?>).value! == nil)
                })
            }.onChange({ row in
                self.recipeBuilder.collection = row.value
                self.toggleNextButton()
            })
            
            section <<< WeightRow(weightRowId) { row in
                row.placeholder = "Default weight"
            }.onChange({ row in
                self.recipeBuilder.defaultWeight = row.value
                self.toggleNextButton()
            })
        }
    }
    
    @IBAction func nextButtonClicked(sender: UIBarButtonItem) {
        if let name = recipeBuilder.name, recipePredicates.isRecipeNameTaken(name: name), !self.editingRecipe {
            let nameTakenAlert = UIAlertController(title: "Sorry, that name is taken", message: "Please choose a different recipe name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            nameTakenAlert.addAction(okAction)
            self.present(nameTakenAlert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "PushToAddIngredientsSegue", sender: sender)
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        if !recipeBuilder.isModified {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let alert = DismissViewHelper.createDismissAlert { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func toggleNextButton() {
        self.nextButton.isEnabled = self.recipeBuilder.isReadyToAddIngredients()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToAddIngredientsSegue" {
            let vc = segue.destination as! AddFlourViewController
            vc.recipeBuilder = recipeBuilder
        }
    }

}
