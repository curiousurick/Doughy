//
//  WeightDecimalRow.swift
//  MyPizzaPal
//
//  Created by urickg on 1/27/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let gram = "g"

public class _WeightRow: FieldRow<WeightCell> {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.formatter = formatter
    }
}

public final class WeightRow: _WeightRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class DefaultWeightRow: _WeightRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class WeightCell: _FieldCell<Double>, CellType {
    
    private let lowerBound: Double = 0
    private var lastValue: Double!
    private let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
    }
    
    public override func update() {
        super.update()
        self.appendWeightIfNecessary()
    }
    
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
    
    public override func textFieldDidChange(_ textField: UITextField) {
        if textField.text == gram
            || textField.text == "-" {
            textField.text = ""
            row.value = nil
            return
        }
        guard let text = textField.text, text != "" else {
            row.value = nil
            return
        }
        var doubleValue = getDoubleValue(text: text)
        if limitValue(doubleValue: &doubleValue) {
            let limited = String(format: "%d", Int(doubleValue))
            textField.text = "\(limited)"
        }
        lastValue = doubleValue
        super.textFieldDidChange(textField)
    }
    
    public override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        guard var text = textField.text, textField.text != "" else { return }
        text = text.replacingOccurrences(of: gram, with: "")
        let doubleValue = getDoubleValue(text: text)
        if (text.contains(".") && floor(doubleValue) == doubleValue) {
            text = "\(Int(doubleValue))"
        }
        textField.text = text
        DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
    }
    
    public override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        self.appendWeightIfNecessary()
    }
    
    private func limitValue(doubleValue: inout Double) -> Bool {
        if lowerBound > doubleValue {
            doubleValue = lastValue
            return true
        }
        return false
    }
    
    fileprivate func appendWeightIfNecessary() {
        guard var text = textField.text, text != ""
            && text != gram
            && !textField.isFirstResponder
            else { return }
        text += gram
        textField.text = text
    }
    
    func getDoubleValue(text: String) -> Double {
        let onlyNumbers = text.components(separatedBy: allowedCharacters.inverted).joined()
        return Double(onlyNumbers)!
    }
}
