//
//  CoreDataCloudDeclaration.swift
//  CaddyList
//
//  Created by Rodolphe DUPUY on 28/07/2020.
//  Copyright © 2020 Rodolphe DUPUY. All rights reserved.
//

import CoreData

class CoreDataCloudDeclaration {
    
    // MARK: - Core Data stack

    public static var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "CaddyList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
//                // Create a store description for a local store
//                let localStoreLocation = URL(fileURLWithPath: "/path/to/local.store")
//                let localStoreDescription =
//                    NSPersistentStoreDescription(url: localStoreLocation)
//                localStoreDescription.configuration = "Local"
//
//                // Create a store description for a CloudKit-backed local store
//                let cloudStoreLocation = URL(fileURLWithPath: "/path/to/cloud.store")
//                let cloudStoreDescription =
//                    NSPersistentStoreDescription(url: cloudStoreLocation)
//                cloudStoreDescription.configuration = "Cloud"
//
//                // Set the container options on the cloud store
//                cloudStoreDescription.cloudKitContainerOptions =
//                    NSPersistentCloudKitContainerOptions(
//                        containerIdentifier: "iCloud.net.roddata.LifeGoals") //"com.my.container")
//
//                // Update the container's list of store descriptions
//                container.persistentStoreDescriptions = [
//                    cloudStoreDescription,
//                    localStoreDescription
//                ]
//
//                // Load both stores
//                container.loadPersistentStores { storeDescription, error in
//                    guard error == nil else {
//                        fatalError("Could not load persistent stores. \(error!)")
//                    }
//                }
        
        return container
    }()
    
//    lazy var persistentContainer: NSPersistentCloudKitContainer = {
//        let container = NSPersistentCloudKitContainer(name: "Earthquakes")
//
//        // Create a store description for a local store
//        let localStoreLocation = URL(fileURLWithPath: "/path/to/local.store")
//        let localStoreDescription =
//            NSPersistentStoreDescription(url: localStoreLocation)
//        localStoreDescription.configuration = "Local"
//
//        // Create a store description for a CloudKit-backed local store
//        let cloudStoreLocation = URL(fileURLWithPath: "/path/to/cloud.store")
//        let cloudStoreDescription =
//            NSPersistentStoreDescription(url: cloudStoreLocation)
//        cloudStoreDescription.configuration = "Cloud"
//
//        // Set the container options on the cloud store
//        cloudStoreDescription.cloudKitContainerOptions =
//            NSPersistentCloudKitContainerOptions(
//                containerIdentifier: "com.my.container")
//
//        // Update the container's list of store descriptions
//        container.persistentStoreDescriptions = [
//            cloudStoreDescription,
//            localStoreDescription
//        ]
//
//        // Load both stores
//        container.loadPersistentStores { storeDescription, error in
//            guard error == nil else {
//                fatalError("Could not load persistent stores. \(error!)")
//            }
//        }
//
//        return container
//    }()
    
    // MARK: - Core Data Saving support

    public static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


