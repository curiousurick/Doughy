//
//  ShowCalculatedRecipeViewController.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class ShowCalculatedRecipeViewController: UITableViewController {
    
    private let cellFactory = CalculatedRecipeCellFactory.shared
    
    var calculatedRecipe: CalculatedRecipe!
    var doughType: DoughType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
