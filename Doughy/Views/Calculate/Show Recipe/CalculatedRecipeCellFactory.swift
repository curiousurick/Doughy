//
//  CalculatedRecipeCellFactory.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedRecipeCellFactory: NSObject {
    
    static let shared = CalculatedRecipeCellFactory()
    
    private let strategies: [CellFactoryStrategy]
    
    private override init() {
        self.strategies = [
            PrefermentCellFactoryStrategy(),
            IngredientCellFactoryStrategy(),
            IngredientWithPrefermentCellFactoryStrategy(),
            InstructionCellFactoryStrategy()
        ]
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell {
        for strategy in strategies {
            if strategy.canHandle(for: indexPath.section, recipe: recipe) {
                return strategy.getCell(tableView: tableView, indexPath: indexPath, recipe: recipe)
            }
        }
        // Should never happen
        fatalError()
    }
    
    func getHeader(tableView: UITableView, section: Int, recipe: CalculatedRecipe) -> String {
        for strategy in strategies {
            if strategy.canHandle(for: section, recipe: recipe) {
                return strategy.getHeader(recipe: recipe)
            }
        }
        // Should never happen
        fatalError()
    }
    
    func getHeight(tableView: UITableView, section: Int, recipe: CalculatedRecipe) -> CGFloat {
        for strategy in strategies {
            if strategy.canHandle(for: section, recipe: recipe) {
                return strategy.getHeight(tableView: tableView, recipe: recipe)
            }
        }
        // Should never happen
        fatalError()
    }

}

fileprivate protocol CellFactoryStrategy {
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell
    func canHandle(for section: Int, recipe: CalculatedRecipe) -> Bool
    func getHeader(recipe: CalculatedRecipe) -> String
    func getHeight(tableView: UITableView, recipe: CalculatedRecipe) -> CGFloat
}

fileprivate class PrefermentCellFactoryStrategy: CellFactoryStrategy {
    
    let cellTag = "PrefermentListCell"
    
    func canHandle(for section: Int, recipe: CalculatedRecipe) -> Bool {
        return recipe.preferment != nil && section == 0
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTag) as! PrefermentListCell
        
        cell.recipe = recipe
        
        return cell
    }
    
    func getHeader(recipe: CalculatedRecipe) -> String {
        let preferment = recipe.preferment!.name!
        return "\(preferment) Ingredients"
    }
    
    func getHeight(tableView: UITableView, recipe: CalculatedRecipe) -> CGFloat {
        let ingredientCounts = Double(recipe.preferment!.ingredients!.count)
        // Height of rows is 30
        // Height of headline is 17
        // Distance from headline to table is 8
        // Bottom white space is 2
        let headlineHeight = 17.0
        let bottomWhiteSpace = 2.0
        let topHeight = 4.0
        let headlineTableDistance = 4.0
        let ingredientCellHeight = 30.0
        let cellHeight = (ingredientCellHeight * ingredientCounts) + headlineHeight + topHeight + headlineTableDistance + bottomWhiteSpace
        return CGFloat(cellHeight)
    }
}

fileprivate class IngredientCellFactoryStrategy: CellFactoryStrategy {
    
    let cellTag = "IngredientListCell"
    
    func canHandle(for section: Int, recipe: CalculatedRecipe) -> Bool {
        return (recipe.preferment == nil && section == 0)
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTag) as! IngredientListCell
        
        cell.recipe = recipe
        
        return cell
    }
    
    func getHeader(recipe: CalculatedRecipe) -> String {
        return "Dough"
    }
    
    func getHeight(tableView: UITableView, recipe: CalculatedRecipe) -> CGFloat {
        let ingredientCounts = Double(recipe.ingredients!.count)
        let prefermentCount = recipe.preferment == nil ? 0.0 : 1.0
        // Height of rows is 30 (Multiply by ingredients. Also add 1 row for preferment
        // Height of headline is 17
        // Distance from headline to table is 8
        // Bottom white space is 2
        let headlineHeight = 33.5
        let bottomWhiteSpace = 2.0
        let topHeight = 4.0
        let headlineTableDistance = 4.0
        let ingredientCellHeight = 30.0
        let rowHeight = (ingredientCellHeight * (ingredientCounts + prefermentCount))
        let headerHeight = headlineHeight + topHeight + headlineTableDistance + bottomWhiteSpace
        let cellHeight = rowHeight + headerHeight
        return CGFloat(cellHeight)
    }
    
}

fileprivate class IngredientWithPrefermentCellFactoryStrategy: CellFactoryStrategy {
    
    let cellTag = "IngredientWithPrefermentListCell"
    
    func canHandle(for section: Int, recipe: CalculatedRecipe) -> Bool {
        return (recipe.preferment != nil && section == 1)
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTag) as! IngredientWithPrefermentListCell
        
        cell.recipe = recipe
        
        return cell
    }
    
    func getHeader(recipe: CalculatedRecipe) -> String {
        return "Dough"
    }
    
    func getHeight(tableView: UITableView, recipe: CalculatedRecipe) -> CGFloat {
        let ingredientCounts = Double(recipe.ingredients!.count)
        let prefermentCount = recipe.preferment == nil ? 0.0 : 1.0
        // Height of rows is 30 (Multiply by ingredients. Also add 1 row for preferment
        // Height of headline is 17
        // Distance from headline to table is 8
        // Bottom white space is 2
        let noticeHeight = 44.0
        let headlineHeight = 33.5
        let bottomWhiteSpace = 2.0
        let topHeight = 4.0
        let headlineTableDistance = 4.0
        let ingredientCellHeight = 30.0
        let rowHeight = (ingredientCellHeight * (ingredientCounts + prefermentCount))
        let headerHeight = headlineHeight + topHeight + headlineTableDistance + bottomWhiteSpace
        let cellHeight = rowHeight + headerHeight + noticeHeight
        return CGFloat(cellHeight)
    }
    
}

fileprivate class InstructionCellFactoryStrategy: CellFactoryStrategy {
    
    let cellTag = "InstructionListCell"
    
    func canHandle(for section: Int, recipe: CalculatedRecipe) -> Bool {
        return (recipe.preferment != nil && section == 2)
            || (recipe.preferment == nil && section == 1)
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath, recipe: CalculatedRecipe) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTag) as! InstructionListCell
        
        let instructions = recipe.instructions?.array as! [Instruction]
        cell.configureWithText(instructions: instructions)
        
        return cell
    }
    
    func getHeader(recipe: CalculatedRecipe) -> String {
        return "Instructions"
    }
    
    func getHeight(tableView: UITableView, recipe: CalculatedRecipe) -> CGFloat {
        let instructions = recipe.instructions?.array as! [Instruction]
        return CGFloat(InstructionListCell.cellHeightWithText(instructions: instructions,
                                                                       tableView: tableView,
                                                                       reuserID: cellTag))
    }
}
