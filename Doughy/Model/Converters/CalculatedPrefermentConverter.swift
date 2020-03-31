//
//  CalculatedPrefermentConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedPrefermentConverter: NSObject {
    let objectFactory = ObjectFactory.shared
    let calculatedIngredientConverter = CalculatedIngredientConverter.shared
    
    static let shared = CalculatedPrefermentConverter()
    
    private override init() { }
    
    func convertToCoreData(preferment: CalculatedPreferment) -> XCCalculatedPreferment {
        let coreData = objectFactory.createCalculatedPreferment()
        
        coreData.name = preferment.name
        coreData.flourPercentage = NSNumber(floatLiteral: preferment.flourPercentage)
        coreData.weight = NSNumber(floatLiteral: preferment.weight)
        preferment.ingredients.forEach {
            coreData.addToIngredients(calculatedIngredientConverter.convertToCoreData(ingredient: $0))
        }
        
        return coreData
    }
    
    func convertToExternal(preferment: XCCalculatedPreferment) -> CalculatedPreferment {
        let name = preferment.name!
        let flourPercentage = preferment.flourPercentage!.doubleValue
        let weight = preferment.weight!.doubleValue
        let ingredients = (preferment.ingredients!.array as! [XCCalculatedIngredient]).map {
            calculatedIngredientConverter.convertToExternal(ingredient: $0)
        }
        
        return CalculatedPreferment(name: name, flourPercentage: flourPercentage, weight: weight, ingredients: ingredients)
    }
}
