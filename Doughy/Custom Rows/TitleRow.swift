//
//  TitleRow.swift
//  Doughy
//
//  Created by urickg on 4/2/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

/// A String valued row where the user can enter names. Biggest difference to TextRow is that it autocapitalization is set to Words.
public final class TitleRow: _TitleRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

open class _TitleRow: FieldRow<TitleCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

open class TitleCell: _FieldCell<String>, CellType {

    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.keyboardType = .asciiCapable
    }
}
