//
//  ShowCalculatedRecipeViewController.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

fileprivate let saveErrorTitle = "Error"
fileprivate let saveErrorMessage = "Failed to save this recipe."
fileprivate let saveSuccessTitle = "Success!"
fileprivate let saveSuccessMessage = "Go to the history tab to see this recipe and take notes on how it turned out!"

class ShowCalculatedRecipeBaseViewController: UITableViewController {
    
    private let prefermentListCellNib: UINib!
    private let ingredientListCellNib: UINib!
    private let ingredientWithPrefermentListCellNib: UINib!
    private let instructionListCellNib: UINib!
    
    private let cellFactory = CalculatedRecipeCellFactory.shared
    
    var calculatedRecipe: CalculatedRecipe!
    var doughType: DoughType!
    
    required init?(coder: NSCoder) {
        self.prefermentListCellNib = UINib(nibName: "PrefermentListCell", bundle: nil)
        self.ingredientListCellNib = UINib(nibName: "IngredientListCell", bundle: nil)
        self.ingredientWithPrefermentListCellNib = UINib(nibName: "IngredientWithPrefermentListCell", bundle: nil)
        self.instructionListCellNib = UINib(nibName: "InstructionListCell", bundle: nil)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(self.prefermentListCellNib, forCellReuseIdentifier: "PrefermentListCell")
        tableView.register(self.ingredientListCellNib, forCellReuseIdentifier: "IngredientListCell")
        tableView.register(self.ingredientWithPrefermentListCellNib, forCellReuseIdentifier: "IngredientWithPrefermentListCell")
        tableView.register(self.instructionListCellNib, forCellReuseIdentifier: "InstructionListCell")
        
        if calculatedRecipe.preferment != nil {
            doughType = .preferment
        }
        else {
            doughType = .straight
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let baseCount = doughType == .preferment ? 2 : 1
        let hasInstructions = !calculatedRecipe.instructions.isEmpty
        return hasInstructions ? baseCount + 1 : baseCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellFactory.getHeader(tableView: tableView, section: section, recipe: calculatedRecipe)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellFactory.getHeight(tableView: tableView, section: indexPath.section, recipe: calculatedRecipe)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory.getCell(tableView: tableView, indexPath: indexPath, recipe: calculatedRecipe)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is InstructionListCell {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

enum DoughType {
    case preferment
    case straight
}
