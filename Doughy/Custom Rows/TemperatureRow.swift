//
//  PercentRow.swift
//  MyPizzaPal
//
//  Created by urickg on 1/27/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let degree = "º"
fileprivate let percentLength = 1

public class _TemperatureRow: FieldRow<TemperatureCell> {
    
    var limit: Range<Double>!
    
    public required init(tag: String?) {
        super.init(tag: tag)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.formatter = formatter
        self.limit = 0..<1000
    }
}

public final class TemperatureRow: _TemperatureRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class TemperatureCell: _FieldCell<Double>, CellType {
    
    var limit: Range<Double>?
    var lastValue: Double!
    
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
        self.limit = (self.row as! TemperatureRow).limit
    }
    
    public override func update() {
        super.update()
        self.appendPercentIfNecessary()
    }
    
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
    
    public override func textFieldDidChange(_ textField: UITextField) {
        if textField.text == degree || textField.text == "-" {
            textField.text = ""
            row.value = nil
            return
        }
        guard let text = textField.text, text != "" else {
            row.value = nil
            return
        }
        if var doubleValue = Double(text) {
            if limitValue(doubleValue: &doubleValue) {
                let limited = String(format: "%d", Int(doubleValue))
                textField.text = "\(limited)"
            }
            lastValue = doubleValue
        }
        super.textFieldDidChange(textField)
    }
    
    public override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        textField.text = textField.text?.replacingOccurrences(of: degree, with: "")
        guard var text = textField.text else { return }
        if let doubleValue = Double(text) {
            if (text.contains(".") && floor(doubleValue) == doubleValue) {
                text = "\(Int(doubleValue))"
            }
        }
        textField.text = text
        DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
    }
    
    public override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        self.appendPercentIfNecessary()
    }
    
    fileprivate func appendPercentIfNecessary() {
        guard var text = textField.text, text != ""
            && text != degree
            && !textField.isFirstResponder
            else { return }
        text += degree
        textField.text = text
    }
    
    private func limitValue(doubleValue: inout Double) -> Bool {
        if let limit = limit {
            if limit.lowerBound > doubleValue {
                doubleValue = lastValue
                return true
            }
            if limit.upperBound < doubleValue {
                doubleValue = lastValue
                return true
            }
        }
        return false
    }
}
