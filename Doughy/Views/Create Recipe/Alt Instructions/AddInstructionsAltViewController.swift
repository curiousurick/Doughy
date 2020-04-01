//
//  AddInstructionsAltViewController.swift
//  Doughy
//
//  Created by urickg on 3/31/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class AddInstructionsAltViewController: UITableViewController, AddStepCellDelegate {
    
    var recipeBuilder: RecipeBuilder!
    
    var instructions: [Instruction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEditing = true
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.addInstruction()
    }
    
    func addInstruction() {
        instructions.append(Instruction(step: ""))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == instructions.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInstructionCell") as! AddStepCell
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as! TextViewTableViewCell
        cell.instruction = instructions[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row < instructions.count {
//            let cell = tableView.cellForRow(at: indexPath) as! TextViewTableViewCell
//            cell.textView.becomeFirstResponder()
//        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < instructions.count
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < instructions.count
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row < instructions.count {
            return proposedDestinationIndexPath
        }
        else {
            return IndexPath(row: instructions.count - 1, section: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let toMove = instructions[sourceIndexPath.row]
        instructions.remove(at: sourceIndexPath.row)
        instructions.insert(toMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.deleteRow(tableView: self.tableView, at: indexPath)
        })]
    }
    
    func deleteRow(tableView: UITableView, at indexPath: IndexPath) {
        tableView.beginUpdates()
        instructions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func addStep() {
        let indexPath = IndexPath(row: instructions.count, section: 0)
        self.addInstruction()
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

}
