//
//  PersistentContainer.swift
//  LifeGoals
//
//  Created by Rodolphe DUPUY on 12/04/2020.
//  Copyright © 2020 Rodolphe DUPUY. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
