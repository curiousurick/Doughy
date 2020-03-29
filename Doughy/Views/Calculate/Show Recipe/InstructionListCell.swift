//
//  InstructionListTableViewCell.swift
//  Doughy
//
//  Created by urickg on 3/22/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

private var sizingCell : InstructionListCell?

class InstructionListCell: UITableViewCell {

    @IBOutlet weak var instructionView: InstructionTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithText(instructions: [Instruction]) -> Void {
        instructionView.text = InstructionListCell.textFromInstructions(instructions: instructions)
    }
    
    static func textFromInstructions(instructions: [Instruction]) -> String {
        var value = ""
        for (index, element) in instructions.enumerated() {
            value += "\(index + 1). "
            value += element.step!
            if element != instructions.last {
                value += "\n\n"
            }
        }
        return value
    }
    
    static func cellHeightWithText(instructions: [Instruction],
                                   tableView: UITableView,
                                   reuserID: String) -> Double {
        if (sizingCell == nil) {
            sizingCell = tableView.dequeueReusableCell(withIdentifier: reuserID) as? InstructionListCell
            sizingCell?.instructionView.isScrollEnabled = false
        }
        sizingCell?.configureWithText(instructions: instructions)
        sizingCell?.setNeedsLayout()
        sizingCell?.layoutIfNeeded()
        sizingCell?.instructionView.preferredWidth = Double(sizingCell!.instructionView.bounds.size.width)
      
        let size = sizingCell?.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        print("TextViewSize:\(sizingCell!.instructionView.intrinsicContentSize)\n")
        print("cellSize:\(size!)\n\n")
       
        return Double(size!.height)
    }
}

class InstructionTextView: UITextView {

    var preferredWidth = 10.0;
    override var intrinsicContentSize: CGSize {
        let preferredSize = CGSize(width: CGFloat(preferredWidth), height: 0.0)
        return sizeThatFits(preferredSize)
    }

}
