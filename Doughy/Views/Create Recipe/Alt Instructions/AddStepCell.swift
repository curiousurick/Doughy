//
//  AddStepCell.swift
//  Doughy
//
//  Created by urickg on 3/31/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

protocol AddStepCellDelegate {
    func addStep()
}

class AddStepCell: UITableViewCell {
    
    var delegate: AddStepCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addStepButtonClicked(sender: UIButton!) {
        self.delegate?.addStep()
    }

}
