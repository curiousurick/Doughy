//
//  PrefermentListTableViewCell.swift
//  Doughy
//
//  Created by urickg on 3/28/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class PrefermentListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    private let weightFormatter = WeightFormatter.shared
    
    @IBOutlet weak var tableView: UITableView!
    var prefermentCellNib: UINib!
    
    var recipe: CalculatedRecipe!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prefermentCellNib = UINib(nibName: "PrefermentCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(self.prefermentCellNib, forCellReuseIdentifier: "PrefermentCell")
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
        return recipe.preferment!.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrefermentCell") as! PrefermentCell
        
        let ingredient = recipe.preferment!.ingredients[indexPath.row]
        let name = ingredient.name
        if let temp = ingredient.temperature {
            let formattedTemp = TemperatureFormatter.shared.format(temperature: temp)
            cell.nameLabel.text = "\(name) (\(formattedTemp))"
        }
        else {
            cell.nameLabel.text = name
        }
        let weight = ingredient.weight
        cell.weightLabel.text = weightFormatter.format(weight: NSNumber(floatLiteral: weight))
        return cell
    }

}
