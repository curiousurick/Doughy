//
//  PrefermentConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class PrefermentConverter: NSObject {
    
    let objectFactory = ObjectFactory.shared
    let ingredientConverter = IngredientConverter.shared
    
    static let shared = PrefermentConverter()
    
    private override init() { }
    
    func convertToCoreData(preferment: Preferment) -> XCPreferment {
        let coreData = objectFactory.createPreferment()
        
        coreData.name = preferment.name
        coreData.flourPercentage = NSNumber(floatLiteral: preferment.flourPercentage)
        preferment.ingredients.forEach {
            coreData.addToIngredients(ingredientConverter.convertToCoreData(ingredient: $0))
        }
        
        return coreData
    }
    
    func convertToExternal(preferment: XCPreferment) -> Preferment {
        let name = preferment.name!
        let flourPercentage = preferment.flourPercentage!.doubleValue
        let ingredients = (preferment.ingredients!.array as! [XCIngredient]).map {
            ingredientConverter.convertToExternal(ingredient: $0)
        }
        
        return Preferment(name: name, flourPercentage: flourPercentage, ingredients: ingredients)
    }
    
    

}
