//
//  AllRecipesTableViewController.swift
//  MyPizzaPal
//
//  Created by urickg on 1/19/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

let expandingCellId = "expandingCell"
let showRecipeMenuSegueId = "ShowRecipeMenuSegue"
let topInset: CGFloat = 0
let detailRowHeight: CGFloat = 44
let titleHeight: CGFloat = 60

class AllRecipesTableViewController: UITableViewController {
    
    private let recipeWriter = RecipeWriter.shared
    
    var viewModel = RecipeViewModel()
    private var selectedRecipeIndex: (Int, Int)?
    
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = topInset
        tableView.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRecipes), name: .recipeUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshRecipes(_ notification: Notification) {
        viewModel.updateData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showRecipeMenuSegueId {
            let mainViewController = segue.destination as! CalculatorViewController
            mainViewController.recipe = viewModel.recipeForRow(section: selectedRecipeIndex!.0, row: selectedRecipeIndex!.1)
        }
    }
    
    @IBAction func unwindToMainView(_ unwindSegue: UIStoryboardSegue) {
        self.viewModel.updateData()
        self.tableView.reloadData()
    }
}

// MARK: TableView

extension AllRecipesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expandingCell", for: indexPath) as! RecipeDetailCell

        cell.section = indexPath.row
        cell.title = viewModel.titleForRow(row: indexPath.row)
        let recipes = viewModel.collectionForSection(section: indexPath.row).recipes
        cell.updateDetails(details: recipes)
        cell.delegate = self

        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndex = tableView.indexPathForSelectedRow, selectedIndex == indexPath {
            
            tableView.beginUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endUpdates()
            return nil
        }
        
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recipe Collections"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndex = tableView.indexPathForSelectedRow, selectedIndex == indexPath {
            let recipeCount = viewModel.collectionForSection(section: indexPath.row).recipes.count
            return (CGFloat(recipeCount) * detailRowHeight) + titleHeight
        }
        else {
            return titleHeight
        }
    }
}

extension AllRecipesTableViewController: RecipeDetailTableViewDelegate {
    
    func recipeCell(recipeCell: RecipeDetailCell, didSelect row: Int, for section: Int) {
        self.selectedRecipeIndex = (section, row)
        self.performSegue(withIdentifier: showRecipeMenuSegueId, sender: nil)
    }
    
    func recipeCell(recipeCell: RecipeDetailCell, didRunOutOfRecipesIn section: Int) {
        print("Deleting collection")
        //After deleting, we update the model
        self.viewModel.updateData()
        // Deselect because when we delete the collection from table, next collection is expanded height without displaying contents.
        self.tableView.deselectRow(at: IndexPath(row: section, section: 0), animated: true)
        let indexSet = IndexSet(arrayLiteral: 0)
        self.tableView.reloadSections(indexSet, with: .automatic)
    }
    
    func recipeCell(recipeCell: RecipeDetailCell, didRemove row: Int, for section: Int) {
        viewModel.updateData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func recipeCell(recipeCell: RecipeDetailCell, failedToRemove recipe: Recipe, row: Int, for section: Int) {
        let title = "Error"
        let message = "Could not delete the recipe"
        let alert = AlertViewHelper.createErrorAlert(title: title, message: message, completion: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
}
