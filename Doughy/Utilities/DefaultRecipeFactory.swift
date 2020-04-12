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
    
    func create() -> [RecipeProtocol] {
        return [createNeopolitan(),
                createNewYorkPizza(),
                createBagel(),
                createBagelWithPoolish(),
//                createBigaBread(),
//                createfiftyPercentWholeWheatBreadWithBiga()
        ]
    }
    
    private func createNeopolitan() -> Recipe {
        
        let flour = Ingredient(name: "Tipo 00 Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 90, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 60, temperature: waterTemp)
        
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 3, temperature: nil)
        
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.05, temperature: nil)
        
        let ingredients = [flour, water, salt, yeast]
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:
                "Mix all the ingredients.\nAdd water to the mixing bowl. Add yeast to the water and stir until combined. You can let it sit for 10 minutes to proof or move to the next step if you trust your yeast. Then add the flour. Use your hands to combine the ingredients together until fully incorporated. The doughy will be  kind of sticky and won't be smooth yet. Add the salt and incorporate it into the dough until fully mixed up. Should only take about 30 seconds. Cover the mixing bowl with a cloth."))
        instructions.append(Instruction(step:
            "Stretch and fold.\nLet the dough rest for 30 minutes. Then begin your stretch and folds. Remove the cloth. Wet your hands and loosen the dough from the sides. Making sure to keep your hands damp (not dripping, this will add hydration to the dough), grab one edge of the dough. Lift it as far as it will go without tearing (make sure it doesn't tear) and fold it into the center. Turn the bowl and repeat this until you come back to the first spot you folded. Repeat 30 minute rest and stretch and fold 3-4 times until your dough can be stretched so thin, you can see light through it. This is called the window pane test."))
        instructions.append(Instruction(step:
            "Bulk ferment.\nLet the dough sit out on the counter for 8-18 hours, depending on the temperature of the room. What you're looking for is that the dough has doubled in size. Because of the small amount of yeast, it will take a long time to rise. This is a good thing because it lets the yeast release more gas, which helps with flavor. If you find your dough is getting to 2x size too quickly, you can move it to a colder part of the house, or consider moving it to the fridge (for up to 24 hours, long than that in bulk ferment will mean the flour might start to break down if you're using 00 flour. Bread flour can last longer)."))
        instructions.append(Instruction(step:
            "Divide and shape into balls.\n Search on youtube and pick a video to help learn to shape the dough balls. https://www.youtube.com/results?search_query=how+to+shape+pizza+dough+balls It's very difficult to describe by text.  \nIf you just need a refresher, here you go. Dump the mass onto an unfloured counter. Divide the dough into preferred dough ball size. About 270 for a 10 inch pizza. Fold the edges into the center and flip it over. Take your hands and cup around the back of the pizza with pinkies touching and pull the ball toward you. The friction of the counter will cause the front of the dough to tighten into the center. Turn the dough 90º and repeat until the ball is tight and smooth.\nPlace all the dough balls into a tray to proof."))
        instructions.append(Instruction(step:
            "Proof the dough for between 2 and 8 hours at room temperature or 24 hours in the refrigerator."))
        instructions.append(Instruction(step:
            "Shape your pizza.\nThis is again something that is best explained by video. Vito Iacopelli is an excentric pizzaioli who has hundreds of videos on Pizza. Here's his shaping video https://www.youtube.com/watch?v=h75bxDwT1Ko"))
        instructions.append(Instruction(step:
            "Cook at the hottest temperature you can. For home, cook on a baking steel which has been preheated to 500ºF or more for 1 hour. For browning, you can turn on your broiler for the last 2 minutes. You should be able to cook in about 5-8 minutes depending on your surface (stone transfers heat slower than steel) and oven temperature. A wood or gas-fired oven is best. You can cook at 932º F in about 60-90 seconds."))
        
        let name = "Neopolitan Pizza"
        let collection = "Pizza"
        let defaultWeight = 270.0
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, instructions: instructions)
    }
    
    private func createNewYorkPizza() -> Recipe {
        
        let flour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 90, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 62, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.75, temperature: nil)
        let oliveOil = Ingredient(name: "Olive Oil", isFlour: false, defaultPercentage: 3, temperature: nil)
        let sugar = Ingredient(name: "Sugar", isFlour: false, defaultPercentage: 2.6, temperature: nil)
        let ingredients = [flour, water, salt, yeast, oliveOil, sugar]
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:
                "Mix all the ingredients.\nAdd water to the mixing bowl. Add yeast to the water and stir until combined. You can let it sit for 10 minutes to proof or move to the next step if you trust your yeast. Then add the flour. Use your hands to combine the ingredients together until fully incorporated. The doughy will be  kind of sticky and won't be smooth yet. Add the salt and incorporate it into the dough until fully mixed up. Should only take about 30 seconds. Cover the mixing bowl with a cloth."))
        instructions.append(Instruction(step:
            "Put the dough out onto the counter. Knead the dough for about 2-3 minutes. Then rest the dough into mixing bowl for about 15 minutes. Knead the dough for another 2-3 minutes. By now, the dough should be smooth and you should be able to stretch it so thin, you can see light through it. This is called the window pane test."))
        instructions.append(Instruction(step:
            "Bulk ferment.\nLet the dough sit out on the counter for 2-3 hours, depending on the temperature of the room. What you're looking for is that the dough has doubled in size. If you find your dough is getting to 2x size too quickly, you can move it to a colder part of the house. You can also bulk ferment in the refrigerator for 24 hours to give it a longer rise, which improves the flavor."))
        instructions.append(Instruction(step:
            "Divide and shape into balls.\n Search on youtube and pick a video to help learn to shape the dough balls. https://www.youtube.com/results?search_query=how+to+shape+pizza+dough+balls It's very difficult to describe by text.  \nIf you just need a refresher, here you go. Dump the mass onto an unfloured counter. Divide the dough into preferred dough ball size. About 270 for a 10 inch pizza. Fold the edges into the center and flip it over. Take your hands and cup around the back of the pizza with pinkies touching and pull the ball toward you. The friction of the counter will cause the front of the dough to tighten into the center. Turn the dough 90º and repeat until the ball is tight and smooth.\nPlace all the dough balls into a tray to proof."))
        instructions.append(Instruction(step:
            "Proof the dough for between 2 and 8 hours at room temperature or 24 hours in the refrigerator."))
        instructions.append(Instruction(step:
            "Shape your pizza.\nThis is again something that is best explained by video. Pagliacci is a Seattle-based pizza chain that made a few videos a few years ago. They don't make NY style pizza, but their shaping instructions are great. Here's their hand-tossed shaping video https://www.youtube.com/watch?v=VIJlRXMfW50"))
        instructions.append(Instruction(step:
            "Cook at the hottest temperature you can. For home, cook on a baking steel which has been preheated to 500ºF or more for 1 hour. For browning, you can turn on your broiler for the last 2 minutes. You should be able to cook in about 5-8 minutes depending on your surface (stone transfers heat slower than steel) and oven temperature. A gas-fired oven is considered authentic to NY but wood-fired ovens will work as well. You can cook at 750º F in about 3-4 minutes."))
        
        let name = "New York Pizza"
        let collection = "Pizza"
        let defaultWeight = 305.0
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, instructions: instructions)
    }
    
    private func createBigaBread() -> PrefermentRecipe {
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
        
        instructions.append(Instruction(step:
            "Ferment the biga.\nCombine all the ingredients for the biga in a mixing bowl. Stir with hands to combine. Once fully incorporated, cover it and let is rise at room temp for 12-14 hours."))
        instructions.append(Instruction(step:
            "Mix the final dough.\nPut the remaining flour into the mixing container. Add the salt into the flour and stir it to combine. Add the remaining yeast into the flour and salt mixture and stir to combine. Add the remaining water to the bowl with the biga to help it release from the sides. Dump all of the biga and water into the flour mixture. Use your hands to fully incorporate all the ingredients. Use the pincer method along with stretch and fold for only about 1 minute."))
        instructions.append(Instruction(step:
            "Bulk ferment, Stretch and fold the dough.\nThe dough will start its bulk ferment period now. It should only take about 2.5-3 hours to triple in volume. You should stretch and fold the dough 2-3 times in the first 1.5 hours of the rise. Start by letting the dough rest, covered, for 30 minutes. Then use a damp hand to separate the dough from the sides. Then grab one edge of the dough and stretch it up as far as it will go without tearing and fold it into the center of the dough. Turn the container and continue stretching until you go all the way around the dough. Cover and rest the dough for another 30 minutes. You will need to stretch the dough 2-3 times until you are able to stretch the dough thin enough to see light through it. This is called the window pane test."))
        instructions.append(Instruction(step:
            "Divide and shape the dough.\nOnce the dough is tripled in volume, dump it out onto a moderately floured surface. Divide it into individual sized doughs, flouring the edge to make it a little easier to separate. Pre-shape the dough by using a bench scraper to fold the top over into the middle. Then fold the bottom, the left and right sides. Use the bench scraper to flip the dough over. Then with swift motions, use the bench scraper to shove the edge of the dough under itself. You want the dough to tighten a little bit all the way around. Use any of Food Geek's videos to get a good understanding of the pre-shape and shape steps of the dough. Here's an example video but most of his sourdough videos will show the shaping steps. https://www.youtube.com/watch?v=Znv99QbfWGs \nAnother tip is to make sure you pop bubbles, because those can exacerbate while proofing, leading to uneven crumb."))
        instructions.append(Instruction(step:
            "Place into a basket, banneton, batard, etc.\nUse rice flour to cover the cloth in the basket, then carefully place the dough ball seam-side out into the basket. Cover it with cloth and let it proof for 1 hour. The way to know if it's proofed is by denting it with your finger. If it springs back quickly, it's not ready. If it stays poked, it's over-proofed. If it comes back slowly, it's just right."))
        instructions.append(Instruction(step:
            "Preheat your oven to 475º F.\nDo not make the mistake of pre-heating your oven (to 475º F) too late. If you're waiting for your oven, the dough can overproof. You need to take your dutch oven with the lid on and place it in the oven, then pre-heat to 475º F. Do this as soon as you start the proof because a dutch oven's metal can absorb heat, causing the oven to heat up more slowly."))
        instructions.append(Instruction(step:
            "Score and bake.\nWhen the dough is ready, place onto parchment paper. Score the dough however you like, but if you don't score, it won't be able to rise in the oven as well because it can't break through the tight skin of the dough. Once scored, pull out the dutch oven, remove the lid, and carefully transfer the dough into the dutch oven on the parchment paper. Close the lid and place back in the oven.\nBake with the lid on for 30 minutes. Then remove the lid and bake for another 20-25 minutes. You want the bread to be a dark color because that's where the best flavor comes from."))
        instructions.append(Instruction(step:
            "Rest the bread on a rack for 1 hour to let the dough cool down and the inside of the bread will finish baking. Put on a rack so the bottom doesn't get soggy from steam. "))
        
        
        let name = "80% Biga White Bread"
        let collection = "Bread"
        let defaultWeight = 887.32
        
        return PrefermentRecipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: biga, instructions: instructions)
    }
    
    private func createfiftyPercentWholeWheatBreadWithBiga() -> PrefermentRecipe {
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
        instructions.append(Instruction(step:
            "Ferment the biga.\nCombine all the ingredients for the biga in a mixing bowl. Stir with hands to combine. Once fully incorporated, cover it and let is rise at room temp for 12-14 hours."))
        instructions.append(Instruction(step:
            "Mix the final dough.\nPut the whole wheat flour into the mixing container. Add the salt into the flour and stir it to combine. Add the remaining yeast into the flour and salt mixture and stir to combine. Add the remaining water to the bowl with the biga to help it release from the sides. Dump all of the biga and water into the flour mixture. Use your hands to fully incorporate all the ingredients. Use the pincer method along with stretch and fold for only about 1 minute."))
        instructions.append(Instruction(step:
            "Bulk ferment, Stretch and fold the dough.\nThe dough will start its bulk ferment period now. It should only take about 3-4 hours to triple in volume. You should stretch and fold the dough 2-3 times in the first 1.5 hours of the rise. Start by letting the dough rest, covered, for 30 minutes. Then use a damp hand to separate the dough from the sides. Then grab one edge of the dough and stretch it up as far as it will go without tearing and fold it into the center of the dough. Turn the container and continue stretching until you go all the way around the dough. Cover and rest the dough for another 30 minutes. You will need to stretch the dough 2-3 times until you are able to stretch the dough thin enough to see light through it. This is called the window pane test."))
        instructions.append(Instruction(step:
            "Divide and shape the dough.\nOnce the dough is tripled in volume, dump it out onto a moderately floured surface. Divide it into individual sized doughs, flouring the edge to make it a little easier to separate. Pre-shape the dough by using a bench scraper to fold the top over into the middle. Then fold the bottom, the left and right sides. Use the bench scraper to flip the dough over. Then with swift motions, use the bench scraper to shove the edge of the dough under itself. You want the dough to tighten a little bit all the way around. Use any of Food Geek's videos to get a good understanding of the pre-shape and shape steps of the dough. Here's an example video but most of his sourdough videos will show the shaping steps. https://www.youtube.com/watch?v=Znv99QbfWGs \nAnother tip is to make sure you pop bubbles, because those can exacerbate while proofing, leading to uneven crumb."))
        instructions.append(Instruction(step:
            "Place into a basket, banneton, batard, etc.\nUse rice flour to cover the cloth in the basket, then carefully place the dough ball seam-side out into the basket. Cover it with cloth and let it proof for 1 hour. The way to know if it's proofed is by denting it with your finger. If it springs back quickly, it's not ready. If it stays poked, it's over-proofed. If it comes back slowly, it's just right."))
        instructions.append(Instruction(step:
            "Preheat your oven to 475º F.\nDo not make the mistake of pre-heating your oven (to 475º F) too late. If you're waiting for your oven, the dough can overproof. You need to take your dutch oven with the lid on and place it in the oven, then pre-heat to 475º F. Do this as soon as you start the proof because a dutch oven's metal can absorb heat, causing the oven to heat up more slowly."))
        instructions.append(Instruction(step:
            "Score and bake.\nWhen the dough is ready, place onto parchment paper. Score the dough however you like, but if you don't score, it won't be able to rise in the oven as well because it can't break through the tight skin of the dough. Once scored, pull out the dutch oven, remove the lid, and carefully transfer the dough into the dutch oven on the parchment paper. Close the lid and place back in the oven.\nBake with the lid on for 30 minutes. Then remove the lid and bake for another 20-25 minutes. You want the bread to be a dark color because that's where the best flavor comes from."))
        instructions.append(Instruction(step:
            "Rest the bread on a rack for 1 hour to let the dough cool down and the inside of the bread will finish baking. Put on a rack so the bottom doesn't get soggy from steam. "))
        
        let name = "50% Whole Wheat Bread With Biga"
        let collection = "Bread"
        let defaultWeight = 912.7
        
        return PrefermentRecipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: biga, instructions: instructions)
    }
    
    private func createBagel() -> Recipe {
        
        let flour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 95, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 56, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2.3, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.66, temperature: nil)
        let malt = Ingredient(name: "Non-diastic Malt", isFlour: false, defaultPercentage: 4.6, temperature: nil)
        let ingredients = [flour, water, salt, yeast, malt]
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:
                "Autolyse the flour and water.\nIn the bowl of a stand mixer, add the flour and water, leaving a small amount of water separate for the yeast. Mix just until combined. Let it rest for 20 minutes. After 10 minutes, combine the remaining water and the yeast to proof."))
        instructions.append(Instruction(step:
            "Mix the remaining ingredients.\nPour the yeast and water mixture into the mixing bowl. Add the malt powder or malt syrup into the bowl. Begin mixing on low-medium speed for 3 minutes. Then add the salt and continue mixing for another 7-12 minutes. The dough is ready when it's smooth and ideally it should pass the window pane test. You should be able to slowly stretch it so thin, you can see light through it. Once it's been mixed for 15 minutes, though, you don't want to mix any more."))
        instructions.append(Instruction(step:
            "Bulk ferment the dough.\nDump the dough on an unfloured work surface. Tighten the dough into a ball and place in a lightly-oiled bowl, seam-side down. Cover and let it rise for 1-1.5 hours, until it's doubled in size."))
        instructions.append(Instruction(step:
            "Divide and shape into balls.\nDivide the dough into 105-115 gram dough balls. Tighten them like you would a pizza, except these are much smaller. Let them rest for 10 minutes. To shape a bagel, you roll it out into a relatively round rectangle. Roll it up along the long side so you have a tube. Close up the seams by pinching, it doesn't have to be perfect Use the part of your hands above your palm to roll the tube and pull your hands apart to stretch out the tube until it's about 8 inches. Place that part of the hand on one end of the tube. Then grab it and with the other hand, grab the other end and wrap it around the knuckles. With the first hand, take both ends and squeeze them together. Roll this combined piece on the table to make it round and help close up the seams. Repeat this for all the bagels and place on a spray-oiled baking sheet. Wrap the baking sheet in plastic wrap and either let them proof for 1 hour, or rise in the fridge overnight."))
        instructions.append(Instruction(step:
            "Boil the bagels.\nPreheat the oven to 450º F. Then get the boiling water bath ready. You can use 2-3 quarts of water, 1 tbsp of baking soda, and 1.5 tbsp of malt syrup (not powder). Add the baking soda and malt syrup once the water is boiling. If you put the bagels in the fridge, make sure they have rest at room temp for 30-60 minutes before boiling. Boil the bagels in batches, making sure they aren't crowded. They should boil for 30-60 seconds per side and then removed to a drying rack so they can lose excess water. As soon as your done boiling all the bagels, get the desired toppings onto the bagels, such as everything seasoning, sesame seeds, dried garlic, or just flaky salt."))
        instructions.append(Instruction(step:
            "Bake the bagels.\nPlace the bagels into the oven on a baking sheet (or if you're fancy, you can bake these on a baking steel/stone). Baking at 450 for 16-18 minutes, turning the baking sheet 180º halfway through for even baking."))
        
        let name = "Bagels"
        let collection = "Bagels"
        let defaultWeight = 113.0
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, instructions: instructions)
    }
    
    private func createBagelWithPoolish() -> PrefermentRecipe {
        
        let poolishFlour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        let poolishWater = Ingredient(name: "Water", isFlour: false, defaultPercentage: 100, temperature: Temperature(value: 80.0, measurement: .fahrenheit))
        let poolishYeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.5, temperature: nil)
        
        let poolish = Preferment(name: "Poolish", flourPercentage: 50, ingredients: [poolishFlour, poolishWater, poolishYeast])
        
        let flour = Ingredient(name: "Bread Flour", isFlour: true, defaultPercentage: 100, temperature: nil)
        
        let waterTemp = Temperature(value: 95, measurement: .fahrenheit)
        let water = Ingredient(name: "Water", isFlour: false, defaultPercentage: 56, temperature: waterTemp)
        let salt = Ingredient(name: "Fine Sea Salt", isFlour: false, defaultPercentage: 2.3, temperature: nil)
        let yeast = Ingredient(name: "Instant Yeast", isFlour: false, defaultPercentage: 0.66, temperature: nil)
        let malt = Ingredient(name: "Non-diastic Malt", isFlour: false, defaultPercentage: 4.6, temperature: nil)
        let ingredients = [flour, water, salt, yeast, malt]
        
        var instructions = [Instruction]()
        
        instructions.append(Instruction(step:
        "Make the poolish.\nCombine all the poolish ingredients into a bowl. Use your fingers or the handle of a wooden spoon to incorporate completely. Let this ferment for 12-18 hours. It should smell really strong and be bubbly when it's ready."))
        instructions.append(Instruction(step:
            "Mix the ingredients.\nPut the remaining flour into the bowl of a stand mixer. Put the remaining water and yeast into the poolish to help it release from the bowl. Pour the poolish, yeast, and water mixture into the mixing bowl. Add the malt powder or malt syrup into the bowl. Begin mixing on low-medium speed for 3 minutes. Then add the salt and continue mixing for another 7-12 minutes. The dough is ready when it's smooth and ideally it should pass the window pane test. You should be able to slowly stretch it so thin, you can see light through it. Once it's been mixed for 15 minutes, though, you don't want to mix any more."))
        instructions.append(Instruction(step:
            "Bulk ferment the dough.\nDump the dough on an unfloured work surface. Tighten the dough into a ball and place in a lightly-oiled bowl, seam-side down. Cover and let it rise for 1-1.5 hours, until it's doubled in size."))
        instructions.append(Instruction(step:
            "Divide and shape into balls.\nDivide the dough into 105-115 gram dough balls. Tighten them like you would a pizza, except these are much smaller. Let them rest for 10 minutes. To shape a bagel, you roll it out into a relatively round rectangle. Roll it up along the long side so you have a tube. Close up the seams by pinching, it doesn't have to be perfect Use the part of your hands above your palm to roll the tube and pull your hands apart to stretch out the tube until it's about 8 inches. Place that part of the hand on one end of the tube. Then grab it and with the other hand, grab the other end and wrap it around the knuckles. With the first hand, take both ends and squeeze them together. Roll this combined piece on the table to make it round and help close up the seams. Repeat this for all the bagels and place on a spray-oiled baking sheet. Wrap the baking sheet in plastic wrap and either let them proof for 1 hour, or rise in the fridge overnight."))
        instructions.append(Instruction(step:
            "Boil the bagels.\nPreheat the oven to 450º F. Then get the boiling water bath ready. You can use 2-3 quarts of water, 1 tbsp of baking soda, and 1.5 tbsp of malt syrup (not powder). Add the baking soda and malt syrup once the water is boiling. If you put the bagels in the fridge, make sure they have rest at room temp for 30-60 minutes before boiling. Boil the bagels in batches, making sure they aren't crowded. They should boil for 30-60 seconds per side and then removed to a drying rack so they can lose excess water. As soon as your done boiling all the bagels, get the desired toppings onto the bagels, such as everything seasoning, sesame seeds, dried garlic, or just flaky salt."))
        instructions.append(Instruction(step:
            "Bake the bagels.\nPlace the bagels into the oven on a baking sheet (or if you're fancy, you can bake these on a baking steel/stone). Baking at 450 for 16-18 minutes, turning the baking sheet 180º halfway through for even baking."))
        
        let name = "Bagels With Poolish"
        let collection = "Bagels"
        let defaultWeight = 113.0
        
        return PrefermentRecipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: poolish, instructions: instructions)
    }

}
