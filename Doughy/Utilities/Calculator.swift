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
        let totalPercent = ingredients.map { $0.percent }.reduce(0, +)
        var doughIngredients = [CalculatedIngredient]()
        ingredients.forEach { ingredient in
            let actualPercent = ingredient.percent / totalPercent
            let weight = actualPercent * totalWeight
            let calcIngredient = CalculatedIngredient(name: ingredient.ingredient.name, isFlour: ingredient.ingredient.isFlour, percentage: ingredient.percent, totalPercentage: ingredient.percent, temperature: ingredient.ingredient.temperature, weight: weight)
            doughIngredients.append(calcIngredient)
        }
        
        let totalFlourWeight = doughIngredients.filter { $0.isFlour }
            .map { $0.weight }
            .reduce(0, +)
        
        var calculatedPreferment: CalculatedPreferment? = nil
        if let preferment = preferment {
            let prefermentIngredients = preferment.ingredients
            let prefermentFlourWeight = (preferment.flourPercentage / 100) * totalFlourWeight
            let prefermentTotalPercent = prefermentIngredients
                .map { $0.percent }.reduce(0, +)
            
            let prefermentWeight = prefermentFlourWeight * (prefermentTotalPercent / 100)
            var calculatedPrefIngredients = [CalculatedIngredient]()
            for prefIngredient in prefermentIngredients {
                let actualPercent = prefIngredient.percent / prefermentTotalPercent
                let weight = actualPercent * prefermentWeight
                let ingredient = CalculatedIngredient(name: prefIngredient.ingredient.name, isFlour: prefIngredient.ingredient.isFlour, percentage: prefIngredient.percent, totalPercentage: prefIngredient.percent, temperature: prefIngredient.ingredient.temperature, weight: weight)
                calculatedPrefIngredients.append(ingredient)
            }
            calculatedPreferment = CalculatedPreferment(name: preferment.name, flourPercentage: preferment.flourPercentage, weight: prefermentWeight, ingredients: calculatedPrefIngredients)
        }
        
        // Set up total percentages by adding up ingredients in both dough and preferment
        // And calculating the total percentage against flour
        for ingredient in doughIngredients {
            if let prefIngredient = calculatedPreferment?.ingredients.first(where: { $0.name == ingredient.name  }) {
                let totalIngWeight = ingredient.weight
                let doughWeight = totalIngWeight - prefIngredient.weight
                let doughPercentage = (doughWeight / totalFlourWeight) * 100
                let totalPercentage = (totalIngWeight / totalFlourWeight) * 100
                ingredient.percentage = doughPercentage
                ingredient.totalPercentage = totalPercentage
                prefIngredient.totalPercentage = totalPercentage
            }
            else {
                let totalIngWeight = ingredient.weight
                let totalPercentage = (totalIngWeight / totalFlourWeight) * 100
                ingredient.percentage = totalPercentage
                ingredient.totalPercentage = totalPercentage
            }
        }
        
        let calculatedRecipe = CalculatedRecipe(name: recipe.name, weight: totalWeight, ingredients: doughIngredients, preferment: calculatedPreferment, instructions: recipe.instructions)
        
        try validateCalculation(calculatedRecipe: calculatedRecipe)
        
        return calculatedRecipe
    }
    
    func calculate(recipe: Recipe) throws -> CalculatedRecipe {
        let totalWeight = recipe.defaultWeight
        
        let ingredients = recipe.ingredients
        let totalPercent = ingredients
            .map { $0.defaultPercentage }
            .reduce(0, +)
        var doughIngredients = [CalculatedIngredient]()
        ingredients.forEach { ingredient in
            let actualPercent = ingredient.defaultPercentage / totalPercent
            let weight = actualPercent * totalWeight
            let calcIngredient = CalculatedIngredient(name: ingredient.name, isFlour: ingredient.isFlour, percentage: ingredient.defaultPercentage, totalPercentage: ingredient.defaultPercentage, temperature: ingredient.temperature, weight: weight)
            doughIngredients.append(calcIngredient)
        }
        
        let totalFlourWeight = doughIngredients
            .filter { $0.isFlour }
            .map { $0.weight }
            .reduce(0, +)
        
        var calculatedPreferment: CalculatedPreferment? = nil
        if let preferment = recipe.preferment {
            let prefermentIngredients = preferment.ingredients
            let prefermentFlourWeight = (preferment.flourPercentage / 100) * totalFlourWeight
            let prefermentTotalPercent = prefermentIngredients
                .map { $0.defaultPercentage }.reduce(0, +)

            let prefermentWeight = prefermentFlourWeight * (prefermentTotalPercent / 100)
            var calculatedIngredients = [CalculatedIngredient]()
            for prefIngredient in prefermentIngredients {
                let actualPercent = prefIngredient.defaultPercentage / prefermentTotalPercent
                let weight = actualPercent * prefermentWeight
                let calcIngredient = CalculatedIngredient(name: prefIngredient.name, isFlour: prefIngredient.isFlour, percentage: prefIngredient.defaultPercentage, totalPercentage: prefIngredient.defaultPercentage, temperature: prefIngredient.temperature, weight: weight)
                calculatedIngredients.append(calcIngredient)
            }

            calculatedPreferment = CalculatedPreferment(name: preferment.name, flourPercentage: preferment.flourPercentage, weight: prefermentWeight, ingredients: calculatedIngredients)
        }
        
        // Set up total percentages by adding up ingredients in both dough and preferment
        // And calculating the total percentage against flour
        for ingredient in doughIngredients {
            if let prefIngredient = calculatedPreferment?.ingredients.first(where: { $0.name == ingredient.name  }) {
                let totalIngWeight = ingredient.weight
                let doughWeight = totalIngWeight - prefIngredient.weight
                let doughPercentage = (doughWeight / totalFlourWeight) * 100
                let totalPercentage = (totalIngWeight / totalFlourWeight) * 100
                ingredient.percentage = doughPercentage
                ingredient.totalPercentage = totalPercentage
                prefIngredient.totalPercentage = totalPercentage
            }
            else {
                let totalIngWeight = ingredient.weight
                let totalPercentage = (totalIngWeight / totalFlourWeight) * 100
                ingredient.percentage = totalPercentage
                ingredient.totalPercentage = totalPercentage
            }
        }
        
        let calculatedRecipe = CalculatedRecipe(name: recipe.name, weight: totalWeight, ingredients: doughIngredients, preferment: calculatedPreferment, instructions: recipe.instructions)
        
        try validateCalculation(calculatedRecipe: calculatedRecipe)
        
        return calculatedRecipe
        
    }
    
    private func validateCalculation(calculatedRecipe: CalculatedRecipe) throws {
        
        // Check that no weights are negative
        let prefermentIngredients = calculatedRecipe.preferment?.ingredients
        if prefermentIngredients != nil {
            for ingredient in prefermentIngredients! {
                let weight = ingredient.weight
                if ingredient.weight < 0 {
                    throw CalculationError.prefermentNegativeValue(name: ingredient.name, value: weight)
                }
            }
        }
        
        let ingredients = calculatedRecipe.ingredients
        for ingredient in ingredients {
            let weight = ingredient.weight
            
            let matchingIngredient = prefermentIngredients?.first { $0.name == ingredient.name }
            let prefermentWeight = matchingIngredient?.weight ?? 0
            let doughWeight = weight - prefermentWeight
            if doughWeight < 0 {
                throw CalculationError.finalDoughNegativeValue(name: ingredient.name, value: doughWeight)
            }
        }
    }

}

enum CalculationError: Error {
    case finalDoughNegativeValue(name: String, value: Double)
    case prefermentNegativeValue(name: String, value: Double)
}
