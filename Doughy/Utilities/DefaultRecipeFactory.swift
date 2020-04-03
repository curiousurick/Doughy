//
//  DefaultRecipeFactory.swift
//  Doughy
//
//  Created by urickg on 3/21/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class DefaultRecipeFactory: NSObject {
    
    private let objectFactory = ObjectFactory.shared
    private let tempConverter = TemperatureConverter.shared
    
    static let shared = DefaultRecipeFactory()
    
    private override init() { }
    
    func create() -> [Recipe] {
        return [createNeopolitan(),
                createNewYorkPizza(),
                createBigaBread(),
                createfiftyPercentWholeWheatBreadWithBiga()]
    }
    
    private func createNeopolitan() -> Recipe {
        
        let flour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 55, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 70, temperature: waterTemp)
        
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 3, temperature: nil)
        
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.2, temperature: nil)
        
        let ingredients = [flour, water, salt, yeast]
        
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:
                "Add water to the mixing bowl. Without water you probably won't have a very good pizza."))
        instructions.append(Instruction(step:
            "Add salt to the water and stir until combined. Salt makes the pizza not taste like shit"))
        instructions.append(Instruction(step:
            "Add yeast to the water and stir until combined. Without yeast, it'll have texture like cardboard. You really don't want that"))
        instructions.append(Instruction(step:
            "Mix with a dough hook until combined. Just combine it. Don't overwork at this step because you need to let it hydrate. I'm still not sure why this is helpful"))
        instructions.append(Instruction(step:
            "Autolyse the dough for 30 minutes. Again, no idea what this step does."))
        instructions.append(Instruction(step:
            "Mix with dough hook for 2 minutes. Only 2 more minutes. Resting and folding is going to be what adds the strength for this recipe."))
        instructions.append(Instruction(step:
            "Rest in rising bucked for 2 hours. After 15 minutes, fold, and fold one more time after 20 more minutes."))
        instructions.append(Instruction(step:
            "Divide the dough and tighten each ball by taking your hands and use your pinkies to pull the ball toward you. Turn it 90º and repeat until the seam on the bottom is tightly closed."))
        instructions.append(Instruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        instructions.append(Instruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        instructions.append(Instruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        instructions.append(Instruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        instructions.append(Instruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        instructions.append(Instruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        instructions.append(Instruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        instructions.append(Instruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        
        let name = "Neopolitan Pizza"
        let collection = "Pizza"
        let defaultWeight = 270.0
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: nil, instructions: instructions)
    }
    
    private func createNewYorkPizza() -> Recipe {
        
        let flour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 90, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 65, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.75, temperature: nil)
        let oliveOil = Ingredient(name: "Olive Oil", isFlour: false, defaultPercentage: 5, temperature: nil)
        let sugar = Ingredient(name: "Sugar", isFlour: false, defaultPercentage: 2, temperature: nil)
        let ingredients = [flour, water, salt, yeast, oliveOil, sugar]
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:"Mix"))
        instructions.append(Instruction(step:"Fold"))
        instructions.append(Instruction(step:"Rise"))
        instructions.append(Instruction(step:"Proof"))
        instructions.append(Instruction(step:"Bake"))
        instructions.append(Instruction(step:"Eat"))
        
        let name = "New York Pizza"
        let collection = "Pizza"
        let defaultWeight = 305.0
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: nil, instructions: instructions)
    }
    
    private func createBigaBread() -> Recipe {
        let bigaFlour = Ingredient(name: "White Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        let bigaWaterTemp = Temperature(value: 80, measurement: .fahrenheit)
        let bigaWater = Ingredient(name: "Water", isFlour: false, defaultPercentage: 68, temperature: bigaWaterTemp)
        let bigaYeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.08, temperature: nil)
        let bigaIngredients = [bigaFlour, bigaWater, bigaYeast]
        
        let biga = Preferment(name: "Biga", flourPercentage: 80, ingredients: bigaIngredients)
        
        
        let flour = Ingredient(name: "White Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        let waterTemp = Temperature(value: 105, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 75, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2.2, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.264, temperature: nil)
        let ingredients = [flour, water, salt, yeast]
        
        var instructions = [Instruction]()
        instructions.append(Instruction(step:"Mix"))
        instructions.append(Instruction(step:"Fold"))
        instructions.append(Instruction(step:"Rise"))
        instructions.append(Instruction(step:"Put in the basket"))
        instructions.append(Instruction(step:"Proof"))
        instructions.append(Instruction(step:"Bake"))
        instructions.append(Instruction(step:"Eat"))
        
        let name = "80% Biga White Bread"
        let collection = "Bread"
        let defaultWeight = 887.32
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: biga, instructions: instructions)
    }
    
    private func createfiftyPercentWholeWheatBreadWithBiga() -> Recipe {
        let bigaFlour = Ingredient(name: "White Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        let bigaWaterTemp = Temperature(value: 80, measurement: .fahrenheit)
        let bigaWater = Ingredient(name: "Water", isFlour: false, defaultPercentage: 68, temperature: bigaWaterTemp)
        let bigaYeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.08, temperature: nil)
        let bigaIngredients = [bigaFlour, bigaWater, bigaYeast]
        
        let biga = Preferment(name: "Biga", flourPercentage: 50, ingredients: bigaIngredients)
        
        let flour = Ingredient(name: "White Flour", isFlour: true, defaultPercentage: 50, temperature: nil)
        let wholeWheatFlour = Ingredient(name: "Whole Wheat Flour", isFlour: true, defaultPercentage: 50, temperature: nil)
        let waterTemp = Temperature(value: 100, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 80, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2.2, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.34, temperature: nil)
        let ingredients = [flour, wholeWheatFlour, water, salt, yeast]
        
        var instructions = [Instruction]()
        instructions.append(Instruction(step:"Mix"))
        instructions.append(Instruction(step:"Fold"))
        instructions.append(Instruction(step:"Rise"))
        instructions.append(Instruction(step:"Put in the basket"))
        instructions.append(Instruction(step:"Proof"))
        instructions.append(Instruction(step:"Bake"))
        instructions.append(Instruction(step:"Eat"))
        
        let name = "50% Whole Wheat Bread With Biga"
        let collection = "Bread"
        let defaultWeight = 912.7
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: biga, instructions: instructions)
    }

}
