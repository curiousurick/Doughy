//
//  IngredientListTableViewCell.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientListCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    private let weightFormatter = WeightFormatter.shared
    private let percentFormatter = PercentFormatter.shared
    
    @IBOutlet weak var tableView: UITableView!
    var ingredientCellNib: UINib!
    
    var recipe: CalculatedRecipe!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.ingredientCellNib = UINib(nibName: "IngredientCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(self.ingredientCellNib, forCellReuseIdentifier: "IngredientCell")
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
        return (recipe.ingredients.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientCell
        
        let ingredient = recipe.ingredients[indexPath.row]
        cell.nameLabel.text = ingredient.name
        let weight = NSNumber(floatLiteral: ingredient.weight)
        let percent = NSNumber(floatLiteral: ingredient.totalPercentage)
        cell.weightLabel.text = weightFormatter.format(weight: weight)
        cell.percentageLabel.text = percentFormatter.format(percent: percent)
        return cell
    }

}
