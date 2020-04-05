//
//  RecipeCollection.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class RecipeCollection {
    let name: String
    var recipes: [RecipeProtocol] = []
    
    init(name: String) {
        self.name = name
    }
}
