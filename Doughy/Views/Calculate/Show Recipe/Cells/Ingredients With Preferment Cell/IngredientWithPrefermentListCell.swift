//
//  IngredientListTableViewCell.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientWithPrefermentListCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    private let weightFormatter = WeightFormatter.shared
    private let percentFormatter = PercentFormatter.shared
    
    @IBOutlet weak var tableView: UITableView!
    var ingredientWithPrefermentCellNib: UINib!
    
    var recipe: CalculatedPrefermentRecipe!
    
    let numberFormatter = NumberFormatter()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.ingredientWithPrefermentCellNib = UINib(nibName: "IngredientWithPrefermentCell",
        bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(self.ingredientWithPrefermentCellNib,
                           forCellReuseIdentifier: "IngredientWithPrefermentCell")
        
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
        return (recipe.ingredients.count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientWithPrefermentCell") as! IngredientWithPrefermentCell
        
        // The preferment row
        let preferment = recipe.preferment
        let prefermentIngredients = preferment.ingredients
        if indexPath.row == recipe.ingredients.count {
            cell.nameLabel.text = preferment.name
            cell.weightLabel.text = weightFormatter.format(weight: preferment.weight)
            cell.doughWeightLabel.text = weightFormatter.format(weight: preferment.weight)
            cell.percentageLabel.text = "\(percentFormatter.format(percent: preferment.flourPercentage))*"
            return cell
        }
        let ingredient = recipe.ingredients[indexPath.row]
        let name = ingredient.name
        if let temp = ingredient.temperature {
            let formattedTemp = TemperatureFormatter.shared.format(temperature: temp)
            cell.nameLabel.text = "\(name) (\(formattedTemp))"
        }
        else {
            cell.nameLabel.text = name
        }
        let totalWeight = ingredient.weight
        let matchingPreferment = prefermentIngredients
            .first { $0.name == ingredient.name }
        let prefermentWeight = matchingPreferment?.weight ?? 0.0
        let doughtWeight = totalWeight - prefermentWeight
        let percent = ingredient.totalPercentage
        cell.weightLabel.text = weightFormatter.format(weight: totalWeight)
        cell.doughWeightLabel.text = weightFormatter.format(weight: doughtWeight)
        cell.percentageLabel.text = percentFormatter.format(percent: percent)
        return cell
    }

}
