//
//  Calculator.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    
    private let objectFactory = ObjectFactory.shared
    
    static let shared = Calculator()
    
    private override init() { }
    
    func calculate(ingredients: [MeasuredIngredient],
                   preferment: MeasuredPreferment?,
                   recipe: Recipe,
                   totalWeight: Double) throws -> CalculatedRecipe {
        let calculatedRecipe = objectFactory.createCalculatedRecipe(recipe: recipe, totalWeight: totalWeight)
        
        let totalPercent = ingredients.map { $0.percent }.reduce(0, +)
        ingredients.forEach { ingredient in
            let calcIngredient = objectFactory.createCalculatedIngredient(ingredient: ingredient.ingredient)
            let actualPercent = ingredient.percent / totalPercent
            let weight = actualPercent * totalWeight
            calcIngredient.weight = NSNumber(floatLiteral: weight)
            calculatedRecipe.addToIngredients(calcIngredient)
        }
        
        let totalFlourWeight = (calculatedRecipe.ingredients?.array as! [CalculatedIngredient])
            .filter { $0.isFlour }
            .map { $0.weight!.doubleValue }
            .reduce(0, +)
        let doughIngredients = calculatedRecipe.ingredients?.array as! [CalculatedIngredient]
        
        if let preferment = preferment {
            let prefermentIngredients = preferment.ingredients
            let calculatedPreferment = objectFactory.createCalculatedPreferment(preferment: preferment)
            let prefermentFlourWeight = (preferment.flourPercentage / 100) * totalFlourWeight
            let prefermentTotalPercent = prefermentIngredients
                .map { $0.percent }.reduce(0, +)
            
            let prefermentWeight = prefermentFlourWeight * (prefermentTotalPercent / 100)
            calculatedPreferment.weight = NSNumber(floatLiteral: prefermentWeight)
            for prefIngredient in prefermentIngredients {
                let calcIngredient = objectFactory.createCalculatedIngredient(ingredient: prefIngredient.ingredient)
                let actualPercent = prefIngredient.percent / prefermentTotalPercent
                let weight = actualPercent * prefermentWeight
                calcIngredient.weight = NSNumber(floatLiteral: weight)
                calcIngredient.percentage = NSNumber(floatLiteral: prefIngredient.percent)
                calculatedPreferment.addToIngredients(calcIngredient)
            }
            
            calculatedRecipe.preferment = calculatedPreferment
        }
        
        // Set up total percentages by adding up ingredients in both dough and preferment
        // And calculating the total percentage against flour
        let calcPreferment = calculatedRecipe.preferment?.ingredients?.array as? [CalculatedIngredient]
        for ingredient in doughIngredients {
            if let prefIngredient = calcPreferment?.first(where: { $0.name == ingredient.name  }) {
                let totalIngWeight = ingredient.weight!.doubleValue
                let doughWeight = totalIngWeight - prefIngredient.weight!.doubleValue
                let doughPercentage = (doughWeight / totalFlourWeight) * 100
                let totalPercentage = NSNumber(floatLiteral: (totalIngWeight / totalFlourWeight) * 100)
                ingredient.percentage = NSNumber(floatLiteral: doughPercentage)
                ingredient.totalPercentage = totalPercentage
                prefIngredient.totalPercentage = totalPercentage
            }
            else {
                let totalIngWeight = ingredient.weight!.doubleValue
                let totalPercentage = NSNumber(floatLiteral: (totalIngWeight / totalFlourWeight) * 100)
                ingredient.percentage = totalPercentage
                ingredient.totalPercentage = totalPercentage
            }
        }
        
        try validateCalculation(calculatedRecipe: calculatedRecipe)
        
        return calculatedRecipe
    }
    
    func calculate(recipe: Recipe) throws -> CalculatedRecipe {
        let totalWeight = recipe.defaultWeight!.doubleValue
        let calculatedRecipe = objectFactory.createCalculatedRecipe(recipe: recipe, totalWeight: totalWeight)
        
        let ingredients = recipe.ingredients!.array as! [Ingredient]
        let totalPercent = ingredients
            .map { $0.defaultPercentage!.doubleValue }
            .reduce(0, +)
        ingredients.forEach { ingredient in
            let calcIngredient = objectFactory.createCalculatedIngredient(ingredient: ingredient)
            let actualPercent = ingredient.defaultPercentage!.doubleValue / totalPercent
            let weight = actualPercent * totalWeight
            calcIngredient.weight = NSNumber(floatLiteral: weight)
            calculatedRecipe.addToIngredients(calcIngredient)
        }
        
        let totalFlourWeight = (calculatedRecipe.ingredients?.array as! [CalculatedIngredient])
            .filter { $0.isFlour }
            .map { $0.weight!.doubleValue }
            .reduce(0, +)
        let doughIngredients = calculatedRecipe.ingredients?.array as! [CalculatedIngredient]
        
//        if let preferment = preferment {
//            let prefermentIngredients = preferment.ingredients
//            let calculatedPreferment = objectFactory.createCalculatedPreferment(preferment: preferment)
//            let prefermentFlourWeight = (preferment.flourPercentage / 100) * totalFlourWeight
//            let prefermentTotalPercent = prefermentIngredients
//                .map { $0.percent }.reduce(0, +)
//
//            let prefermentWeight = prefermentFlourWeight * (prefermentTotalPercent / 100)
//            calculatedPreferment.weight = NSNumber(floatLiteral: prefermentWeight)
//            for prefIngredient in prefermentIngredients {
//                let calcIngredient = objectFactory.createCalculatedIngredient(ingredient: prefIngredient.ingredient)
//                let actualPercent = prefIngredient.percent / prefermentTotalPercent
//                let weight = actualPercent * prefermentWeight
//                calcIngredient.weight = NSNumber(floatLiteral: weight)
//                calcIngredient.percentage = NSNumber(floatLiteral: prefIngredient.percent)
//                calculatedPreferment.addToIngredients(calcIngredient)
//            }
//
//            calculatedRecipe.preferment = calculatedPreferment
//        }
        
        // Set up total percentages by adding up ingredients in both dough and preferment
        // And calculating the total percentage against flour
        let calcPreferment = calculatedRecipe.preferment?.ingredients?.array as? [CalculatedIngredient]
        for ingredient in doughIngredients {
            if let prefIngredient = calcPreferment?.first(where: { $0.name == ingredient.name  }) {
                let totalIngWeight = ingredient.weight!.doubleValue
                let doughWeight = totalIngWeight - prefIngredient.weight!.doubleValue
                let doughPercentage = (doughWeight / totalFlourWeight) * 100
                let totalPercentage = NSNumber(floatLiteral: (totalIngWeight / totalFlourWeight) * 100)
                ingredient.percentage = NSNumber(floatLiteral: doughPercentage)
                ingredient.totalPercentage = totalPercentage
                prefIngredient.totalPercentage = totalPercentage
            }
            else {
                let totalIngWeight = ingredient.weight!.doubleValue
                let totalPercentage = NSNumber(floatLiteral: (totalIngWeight / totalFlourWeight) * 100)
                ingredient.percentage = totalPercentage
                ingredient.totalPercentage = totalPercentage
            }
        }
        
        try validateCalculation(calculatedRecipe: calculatedRecipe)
        
        return calculatedRecipe
        
    }
    
    private func validateCalculation(calculatedRecipe: CalculatedRecipe) throws {
        
        // Check that no weights are negative
        let prefermentIngredients = calculatedRecipe.preferment?.ingredients?.array as? [CalculatedIngredient]
        if prefermentIngredients != nil {
            for ingredient in prefermentIngredients! {
                let weight = ingredient.weight!.doubleValue
                if ingredient.weight!.doubleValue < 0 {
                    throw CalculationError.prefermentNegativeValue(name: ingredient.name!, value: weight)
                }
            }
        }
        
        let ingredients = calculatedRecipe.ingredients!.array as! [CalculatedIngredient]
        for ingredient in ingredients {
            let weight = ingredient.weight!.doubleValue
            
            let matchingIngredient = prefermentIngredients?.first { $0.name == ingredient.name }
            let prefermentWeight = matchingIngredient?.weight?.doubleValue ?? 0
            let doughWeight = weight - prefermentWeight
            if doughWeight < 0 {
                throw CalculationError.finalDoughNegativeValue(name: ingredient.name!, value: doughWeight)
            }
        }
    }

}

enum CalculationError: Error {
    case finalDoughNegativeValue(name: String, value: Double)
    case prefermentNegativeValue(name: String, value: Double)
}
