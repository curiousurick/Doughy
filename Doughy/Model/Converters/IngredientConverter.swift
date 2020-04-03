//
//  IngredientConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientConverter: NSObject {
    
    private let objectFactory = ObjectFactory.shared
    
    static let shared = IngredientConverter()
    
    private override init() { }
    
    func convertToCoreData(ingredient: Ingredient) -> XCIngredient {
        let coreData = objectFactory.createIngredient()
        
        coreData.name = ingredient.name
        coreData.isFlour = ingredient.isFlour
        coreData.defaultPercentage = NSNumber(floatLiteral: ingredient.defaultPercentage)
        if let temperature = ingredient.temperature {
            coreData.temperature = NSNumber(floatLiteral: temperature.value)
        }
        
        return coreData
    }
    
    func convertToExternal(ingredient: XCIngredient) -> Ingredient {
        let name = ingredient.name!
        let defaultPercentage = ingredient.defaultPercentage!.doubleValue
        let isFlour = ingredient.isFlour
        var temperature: Temperature? = nil
        if let temp = ingredient.temperature?.doubleValue {
            temperature = Temperature(value: temp, measurement: Settings.shared.preferredTemp())
        }
        
        return Ingredient(name: name, isFlour: isFlour, defaultPercentage: defaultPercentage, temperature: temperature)
    }
}
