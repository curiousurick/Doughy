//
//  ObjectFactory.swift
//  Doughy
//
//  Created by urickg on 3/21/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import CoreData

class ObjectFactory: NSObject {
    
    private let coreDataGateway = CoreDataGateway.shared
    
    static let shared = ObjectFactory()
    
    private override init() { }
    
    func createRecipe() -> Recipe {
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.coreDataGateway.managedObjectConext)
        return NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! Recipe
    }
    
    func createPreferment() -> Preferment {
        let entity = NSEntityDescription.entity(forEntityName: "Preferment", in: self.coreDataGateway.managedObjectConext)
        return NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! Preferment
    }
    
    func createIngredient() -> Ingredient {
        let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: self.coreDataGateway.managedObjectConext)
        return NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! Ingredient
    }
    
    func createCalculatedRecipe(recipe: Recipe, totalWeight: Double) -> CalculatedRecipe {
        let entity = NSEntityDescription.entity(forEntityName: "CalculatedRecipe", in: self.coreDataGateway.managedObjectConext)
        let item = NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! CalculatedRecipe
        item.name = recipe.name
        item.instructions = recipe.instructions
        item.weight = NSNumber(floatLiteral: totalWeight)
        return item
    }
    
    func createCalculatedPreferment(preferment: MeasuredPreferment) -> CalculatedPreferment {
        let entity = NSEntityDescription.entity(forEntityName: "CalculatedPreferment", in: self.coreDataGateway.managedObjectConext)
        let item = NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! CalculatedPreferment
        item.name = preferment.name
        item.flourPercentage = NSNumber(floatLiteral: preferment.flourPercentage)
        return item
    }
    
    func createCalculatedIngredient(ingredient: Ingredient) -> CalculatedIngredient {
        let entity = NSEntityDescription.entity(forEntityName: "CalculatedIngredient", in: self.coreDataGateway.managedObjectConext)
        let item = NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! CalculatedIngredient
        item.isFlour = ingredient.isFlour
        item.name = ingredient.name
        item.temperature = ingredient.temperature
        return item
    }
    
    func createInstruction(step: String) -> Instruction {
        let entity = NSEntityDescription.entity(forEntityName: "Instruction", in: self.coreDataGateway.managedObjectConext)
        let item = NSManagedObject(entity: entity!, insertInto: self.coreDataGateway.managedObjectConext) as! Instruction
        item.step = step
        return item
    }

}
