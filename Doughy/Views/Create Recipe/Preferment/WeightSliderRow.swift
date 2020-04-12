//
//  WeightSliderRow.swift
//  Doughy
//
//  Created by urickg on 4/5/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let gram = "g"

class WeightSliderCell: _FieldCell<Double>, CellType {
    private var awakeFromNibCalled = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        awakeFromNibCalled = true
        
        downButton.addTarget(self, action: #selector(downButtonDown), for: .touchDown)
        downButton.addTarget(self, action: #selector(downButtonUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit, .touchDragOutside])
        
        upButton.addTarget(self, action: #selector(upButtonDown), for: .touchDown)
        upButton.addTarget(self, action: #selector(upButtonUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit, .touchDragOutside])
    }
    
    override func setup() {
        textField = weightTextField
        super.setup()
        
        // we do not want our cell to be selected in this case. If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        // specify the desired height for our cell
        height = { return 60 }
        
        nameLabel.text = row.title
        weightTextField.text = self.displayValue(useFormatter: true)
    }
    
    override func update() {
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
        detailTextLabel?.text = nil
        
        let enabled = !self.row.isDisabled
        weightTextField.isEnabled = enabled
        upButton.isEnabled = enabled
        downButton.isEnabled = enabled
        
        if !awakeFromNibCalled {
            if let title = row.title {
                switch row.cellStyle {
                case .subtitle:
                    weightTextField.textAlignment = .left
                    weightTextField.clearButtonMode = .whileEditing
                default:
                    weightTextField.textAlignment = title.isEmpty ? .left : .right
                    weightTextField.clearButtonMode = title.isEmpty ? .whileEditing : .never
                }
            } else {
                weightTextField.textAlignment = .left
                weightTextField.clearButtonMode = .whileEditing
            }
        } else {
            textLabel?.text = nil
            nameLabel.text = row.title
            if #available(iOS 13.0, *) {
                nameLabel?.textColor = row.isDisabled ? .tertiaryLabel : .label
            } else {
                nameLabel?.textColor = row.isDisabled ? .gray : .black
            }
        }
    }
    
    var timer: Timer?
    var numberOfRepeats = 0.0
    
    @objc func downButtonDown() {
        decrement()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(decrementAndRepeat), userInfo: nil, repeats: false)
        print("down button down")
    }
    
    @objc func downButtonUp() {
        numberOfRepeats = 0.0
        timer?.invalidate()
        print("down button released")
    }
    
    @objc func decrementAndRepeat() {
        numberOfRepeats += 1
        let speed = 0.03 * min(numberOfRepeats, 8)
        let nextRepeat = 0.3 - speed
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: nextRepeat, target: self, selector: #selector(decrementAndRepeat), userInfo: nil, repeats: false)
        decrement()
    }
    
    func decrement() {
        
        let current = row.value ?? 0
        var potential: Double
        if current > 10 {
            potential = current - 1
        }
        else {
            potential = current - 0.1
        }
        let _ = limitValue(doubleValue: &potential)
        row.value = potential
        weightTextField.text = displayValue(useFormatter: (row as? FormatterConformance)?.formatter != nil)
        weightTextField.resignFirstResponder()
    }
    
    @objc func upButtonDown() {
        increment()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(incrementAndRepeat), userInfo: nil, repeats: false)
        print("up button down")
    }
    
    @objc func upButtonUp() {
        numberOfRepeats = 0.0
        timer?.invalidate()
        print("up button released")
    }
    
    @objc func incrementAndRepeat() {
        numberOfRepeats += 1
        let speed = 0.03 * min(numberOfRepeats, 8)
        let nextRepeat = 0.3 - speed
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: nextRepeat, target: self, selector: #selector(incrementAndRepeat), userInfo: nil, repeats: false)
        increment()
    }
    
    func increment() {
        let current = row.value ?? 0
        var potential: Double
        if current > 9.99 {
            potential = current + 1
        }
        else {
            potential = current + 0.1
        }
        let _ = limitValue(doubleValue: &potential)
        row.value = potential
        weightTextField.text = displayValue(useFormatter: (row as? FormatterConformance)?.formatter != nil)
        weightTextField.resignFirstResponder()
    }
    
    @objc open override func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "-" {
            textField.text = ""
            row.value = 0
            return
        }
        guard let text = textField.text, text != "" else {
            row.value = 0
            return
        }
        super.textFieldDidChange(textField)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        guard var text = textField.text else { return }
        text = text.replacingOccurrences(of: gram, with: "")
        if var doubleValue = Double(text) {
            if limitValue(doubleValue: &doubleValue) {
                let limited = String(format: "%d", Int(doubleValue))
                text = "\(limited)"
                row.value = doubleValue
            }
        }
        guard text != gram && !textField.isFirstResponder else { return }
        text += gram
        textField.text = text
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        let end = textField.endOfDocument
        let textRange = textField.textRange(from: end, to: end)
        DispatchQueue.main.async {
            textField.selectedTextRange = textRange
        }
        
    }
    
    private func limitValue(doubleValue: inout Double) -> Bool {
        guard let formatter = ((row as! WeightSliderRow).formatter as? NumberFormatter) else {
            return false
        }
        if formatter.maximum != nil && formatter.maximum!.doubleValue < doubleValue {
            doubleValue = formatter.maximum!.doubleValue
            return true
        }
        if formatter.minimum != nil && formatter.minimum!.doubleValue > doubleValue {
            doubleValue = formatter.minimum!.doubleValue
            return true
        }
        return false
    }
    
    private func displayValue(useFormatter: Bool) -> String? {
        guard let v = row.value else { return nil }
        if let formatter = (row as? FormatterConformance)?.formatter, useFormatter {
            if let formatted = weightTextField?.isFirstResponder == true ? formatter.editingString(for: v) : formatter.string(for: v) {
                return "\(formatted)\(gram)"
            }
            return nil
        }
        return "\(String(describing: v))\(gram)"
    }
    
}

final class WeightSliderRow: FieldRow<WeightSliderCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<WeightSliderCell>(nibName: "WeightSliderCell")
    }
}
