//
//  CoreDataStorage.swift
//  iOS-UiKit-CleanArchitectureMVVM-kudoleh
//
//  Created by Muker on 5/21/24.
//

import CoreData

final class CoreDataStorage {
    static let shared = CoreDataStorage() // 싱글턴말고 주입으로 해볼까
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage 에러: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage 에러: \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func performBackgroundTask(
        _ block: @escaping (NSManagedObjectContext) -> Void
    ) {
        persistentContainer.performBackgroundTask(block)
    }
}

// MARK: - Extention



// MARK: - Enum

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}


// MARK: - Protocol


