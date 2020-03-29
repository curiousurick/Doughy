//
//  PrefermentListTableViewCell.swift
//  Recipe Helper
//
//  Created by urickg on 3/28/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class PrefermentListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

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
        return recipe.preferment?.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrefermentCell") as! PrefermentTableViewCell
        
        let ingredient = recipe.preferment!.ingredients![indexPath.row] as! CalculatedIngredient
        cell.nameLabel.text = ingredient.name
        let weight = ingredient.weight!
        cell.weightLabel.text = "\(numberFormatter.string(from: weight)!)g"
        return cell
    }

}
