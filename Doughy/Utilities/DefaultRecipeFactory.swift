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
    
    static let shared = DefaultRecipeFactory()
    
    private override init() { }
    
    func create() -> [Recipe] {
        return [createNeopolitan(),
                createNewYorkPizza(),
                createBigaBread(),
                createfiftyPercentWholeWheatBreadWithBiga()]
    }
    
    private func createNeopolitan() -> Recipe {
        let neopolitan = objectFactory.createRecipe()
        
        neopolitan.name = "Neopolitan Pizza"
        neopolitan.collection = "Pizza"
        neopolitan.defaultWeight = 270
        
        let flour = objectFactory.createIngredient()
        flour.name = "Bread Flour"
        flour.defaultPercentage = 100
        flour.isFlour = true
        
        let water = objectFactory.createIngredient()
        water.name = "Water"
        water.defaultPercentage = 70
        water.temperature = 55
        
        let salt = objectFactory.createIngredient()
        salt.name = "Fine Sea Salt"
        salt.defaultPercentage = 3
        
        let yeast = objectFactory.createIngredient()
        yeast.name = "Instant Yeast"
        yeast.defaultPercentage = 0.2
        
        neopolitan.addToIngredients(flour)
        neopolitan.addToIngredients(water)
        neopolitan.addToIngredients(salt)
        neopolitan.addToIngredients(yeast)
        
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
                "Add water to the mixing bowl. Without water you probably won't have a very good pizza."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Add salt to the water and stir until combined. Salt makes the pizza not taste like shit"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Add yeast to the water and stir until combined. Without yeast, it'll have texture like cardboard. You really don't want that"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Mix with a dough hook until combined. Just combine it. Don't overwork at this step because you need to let it hydrate. I'm still not sure why this is helpful"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Autolyse the dough for 30 minutes. Again, no idea what this step does."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Mix with dough hook for 2 minutes. Only 2 more minutes. Resting and folding is going to be what adds the strength for this recipe."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Rest in rising bucked for 2 hours. After 15 minutes, fold, and fold one more time after 20 more minutes."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Divide the dough and tighten each ball by taking your hands and use your pinkies to pull the ball toward you. Turn it 90º and repeat until the seam on the bottom is tightly closed."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Refrigerate for 1-3 days. The second day is ideal. But honestly the next day is fine. The 3rd day will also taste good. Try any of them and compare!"))
        neopolitan.addToInstructions(objectFactory.createInstruction(step:
            "Cook on a baking steel which has been preheated to 500º or more for 1 hour. You should be able to cook in about 5 minutes. May take closer to 8. Don't be afraid to get burn marks though. They taste really good."))
        
        return neopolitan
    }
    
    private func createNewYorkPizza() -> Recipe {
        let newYorkPizza = objectFactory.createRecipe()
        
        newYorkPizza.name = "New York Pizza"
        newYorkPizza.collection = "Pizza"
        newYorkPizza.defaultWeight = 305
        
        let flour = objectFactory.createIngredient()
        flour.name = "Bread Flour"
        flour.defaultPercentage = 100
        flour.isFlour = true
        
        let water = objectFactory.createIngredient()
        water.name = "Water"
        water.defaultPercentage = 65
        water.temperature = 90
        
        let salt = objectFactory.createIngredient()
        salt.name = "Fine Sea Salt"
        salt.defaultPercentage = 2
        
        let yeast = objectFactory.createIngredient()
        yeast.name = "Instant Yeast"
        yeast.defaultPercentage = 0.75
        
        let oliveOil = objectFactory.createIngredient()
        oliveOil.name = "Olive Oil"
        oliveOil.defaultPercentage = 5
        
        let sugar = objectFactory.createIngredient()
        sugar.name = "Sugar"
        sugar.defaultPercentage = 2
        
        newYorkPizza.addToIngredients(flour)
        newYorkPizza.addToIngredients(water)
        newYorkPizza.addToIngredients(salt)
        newYorkPizza.addToIngredients(yeast)
        newYorkPizza.addToIngredients(oliveOil)
        newYorkPizza.addToIngredients(sugar)
        
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Mix"))
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Fold"))
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Rise"))
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Proof"))
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Bake"))
        newYorkPizza.addToInstructions(objectFactory.createInstruction(step: "Eat"))
        
        return newYorkPizza
    }
    
    private func createBigaBread() -> Recipe {
        let bigaBread = objectFactory.createRecipe()
        
        bigaBread.name = "80% Biga White Bread"
        bigaBread.collection = "Bread"
        bigaBread.defaultWeight = 887.32
        
        let biga = objectFactory.createPreferment()
        biga.name = "Biga"
        biga.flourPercentage = 80
        
        let bigaFlour = objectFactory.createIngredient()
        bigaFlour.name = "White Flour"
        bigaFlour.defaultPercentage = 100
        bigaFlour.isFlour = true
        
        let bigaWater = objectFactory.createIngredient()
        bigaWater.name = "Water"
        bigaWater.defaultPercentage = 68
        bigaWater.temperature = 80
        
        let bigaYeast = objectFactory.createIngredient()
        bigaYeast.name = "Instant Yeast"
        bigaYeast.defaultPercentage = 0.064
        
        biga.addToIngredients(bigaFlour)
        biga.addToIngredients(bigaWater)
        biga.addToIngredients(bigaYeast)
        
        let flour = objectFactory.createIngredient()
        flour.name = "White Flour"
        flour.defaultPercentage = 100
        flour.isFlour = true
        
        let water = objectFactory.createIngredient()
        water.name = "Water"
        water.defaultPercentage = 75
        water.temperature = 105
        
        let salt = objectFactory.createIngredient()
        salt.name = "Fine Sea Salt"
        salt.defaultPercentage = 2.2
        
        let yeast = objectFactory.createIngredient()
        yeast.name = "Instant Yeast"
        yeast.defaultPercentage = 0.264
        
        bigaBread.addToIngredients(flour)
        bigaBread.addToIngredients(water)
        bigaBread.addToIngredients(salt)
        bigaBread.addToIngredients(yeast)
        
        bigaBread.preferment = biga
        
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Mix"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Fold"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Rise"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Put in the basket"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Proof"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Bake"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Eat"))
        
        return bigaBread
    }
    
    private func createfiftyPercentWholeWheatBreadWithBiga() -> Recipe {
        let bigaBread = objectFactory.createRecipe()
        
        bigaBread.name = "50% Whole Wheat Bread With Biga"
        bigaBread.collection = "Bread"
        bigaBread.defaultWeight = 912.7
        
        let biga = objectFactory.createPreferment()
        biga.name = "Biga"
        biga.flourPercentage = 50
        
        let bigaFlour = objectFactory.createIngredient()
        bigaFlour.name = "White Flour"
        bigaFlour.defaultPercentage = 100
        bigaFlour.isFlour = true
        
        let bigaWater = objectFactory.createIngredient()
        bigaWater.name = "Water"
        bigaWater.defaultPercentage = 68
        bigaWater.temperature = 80
        
        let bigaYeast = objectFactory.createIngredient()
        bigaYeast.name = "Instant Yeast"
        bigaYeast.defaultPercentage = 0.08
        
        biga.addToIngredients(bigaFlour)
        biga.addToIngredients(bigaWater)
        biga.addToIngredients(bigaYeast)
        
        let whiteFlour = objectFactory.createIngredient()
        whiteFlour.name = "White Flour"
        whiteFlour.defaultPercentage = 50
        whiteFlour.isFlour = true
        
        let wholeWheatFlour = objectFactory.createIngredient()
        wholeWheatFlour.name = "Whole Wheat Flour"
        wholeWheatFlour.defaultPercentage = 50
        wholeWheatFlour.isFlour = true
        
        let water = objectFactory.createIngredient()
        water.name = "Water"
        water.defaultPercentage = 80
        water.temperature = 100
        
        let salt = objectFactory.createIngredient()
        salt.name = "Fine Sea Salt"
        salt.defaultPercentage = 2.2
        
        let yeast = objectFactory.createIngredient()
        yeast.name = "Instant Yeast"
        yeast.defaultPercentage = 0.34
        
        bigaBread.addToIngredients(whiteFlour)
        bigaBread.addToIngredients(wholeWheatFlour)
        bigaBread.addToIngredients(water)
        bigaBread.addToIngredients(salt)
        bigaBread.addToIngredients(yeast)
        
        bigaBread.preferment = biga
        
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Mix"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Fold"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Rise"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Put in the basket"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Proof"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Bake"))
        bigaBread.addToInstructions(objectFactory.createInstruction(step: "Eat"))
        
        return bigaBread
    }

}
