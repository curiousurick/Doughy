//
//  IngredientListTableViewCell.swift
//  Recipe Helper
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientListCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var recipe: CalculatedRecipe!
    
    let numberFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        // Initialization code
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prefermentRow = recipe.preferment == nil ? 0 : 1
        return (recipe.ingredients?.count ?? 0) + prefermentRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientTableViewCell
        
        // The preferment row
        if let preferment = recipe.preferment, indexPath.row == recipe.ingredients!.count {
            cell.nameLabel.text = preferment.name
            let weight = preferment.weight!
            let percent = preferment.flourPercentage!
            cell.weightLabel.text = "\(numberFormatter.string(from: weight)!)g"
            cell.percentageLabel.text = "\(numberFormatter.string(from: percent)!)%"
            return cell
        }
        let ingredient = recipe.ingredients![indexPath.row] as! CalculatedIngredient
        cell.nameLabel.text = ingredient.name
        let weight = ingredient.weight!
        let percent = ingredient.totalPercentage!
        cell.weightLabel.text = "\(numberFormatter.string(from: weight)!)g"
        cell.percentageLabel.text = "\(numberFormatter.string(from: percent)!)%"
        return cell
    }

}
