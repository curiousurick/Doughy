//
//  CoreDataGateway.swift
//  Doughy
//
//  Created by urickg on 3/21/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import CoreData

class CoreDataGateway: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = CoreDataGateway()

    fileprivate lazy var dataController: NSFetchedResultsController<XCRecipe> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<XCRecipe> = XCRecipe.fetchRequest()
        
        // Create Fetched Results Controller
        let sorters = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.sortDescriptors = sorters
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    private let persistentContainer = NSPersistentContainer(name: "Doughy")
    var managedObjectConext: NSManagedObjectContext!
    
    private override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            }
            let _ = self.dataController
            self.managedObjectConext = self.persistentContainer.viewContext
        }
    }
}
