//
//  TextViewTableViewCell.swift
//  Doughy
//
//  Created by urickg on 3/31/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var instruction: Instruction! {
        didSet {
            textView.text = instruction.step
        }
    }
    
    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        // Initialization code
    }

    func textViewDidChange(_ textView: UITextView) {
        print(textView.text!)
        instruction.step = textView.text
    }

}
