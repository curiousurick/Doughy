//
//  ExpandingCell.swift
//  ExpandingStackCells
//
//  Created by József Vesza on 27/06/15.
//  Copyright © 2015 Jozsef Vesza. All rights reserved.
//

import UIKit

protocol RecipeDetailTableViewDelegate {
    
    func recipeCell(recipeCell: RecipeDetailCell, didSelect row: Int, for section: Int)
    func recipeCell(recipeCell: RecipeDetailCell, didRemove row: Int, for section: Int)
    func recipeCell(recipeCell: RecipeDetailCell, failedToRemove recipe: Recipe, row: Int, for section: Int)
    func recipeCell(recipeCell: RecipeDetailCell, didRunOutOfRecipesIn section: Int)
    
}

class RecipeDetailCell: UITableViewCell {
    
    private let recipeWriter = RecipeWriter.shared
    
    var delegate: RecipeDetailTableViewDelegate?
    
    var section: Int!
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private var details: [Recipe]?
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateDetails(details: [Recipe]) {
        self.details = details
        self.detailTableView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animate(withDuration: 0.3){
            self.detailTableView.isHidden = !selected
        }
    }
}

extension RecipeDetailCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.recipeCell(recipeCell: self,
                             didSelect: indexPath.row,
                             for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell")!
        
        cell.textLabel?.text = details![indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = details![indexPath.row]
            do {
                try recipeWriter.deleteRecipe(recipe: toDelete)
            } catch {
                self.delegate?.recipeCell(recipeCell: self, failedToRemove: toDelete, row: indexPath.row, for: section)
                return
            }
            details!.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            if details!.isEmpty {
                self.delegate?.recipeCell(recipeCell: self, didRunOutOfRecipesIn: section)
            }
            else {
                self.delegate?.recipeCell(recipeCell: self, didRemove: indexPath.row, for: section)
            }
        }
    }
    
}
