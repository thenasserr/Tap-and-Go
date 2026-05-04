//
//  CacheCleaner.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation

protocol CacheCleaner {

    func clearUserCache()

}

import Foundation
import CoreData

// MARK: - Default Cache Cleaner

final class DefaultCacheCleaner: CacheCleaner {
    
    private let coreDataStack: CoreDataStack
    private let selectedAddressRepository: SelectedAddressRepository
    
    // MARK: - Init
    
    init(
        coreDataStack: CoreDataStack,
        selectedAddressRepository: SelectedAddressRepository
    ) {
        self.coreDataStack = coreDataStack
        self.selectedAddressRepository = selectedAddressRepository
    }
}

// MARK: - Clear User Cache

extension DefaultCacheCleaner {
    
    func clearUserCache() {
        clearCoreData()
        selectedAddressRepository.clearSelectedAddress()
    }
}

// MARK: - Core Data Cleanup

private extension DefaultCacheCleaner {
    
    func clearCoreData() {
        let context = coreDataStack.newBackgroundContext()
        
        context.perform {
            self.deleteEntity("CartItemEntity", in: context)
            self.deleteEntity("OrderEntity", in: context)
            self.deleteEntity("PaymentEntity", in: context)
            self.deleteEntity("FavoriteEntity", in: context)
            self.deleteEntity("AddressEntity", in: context)
            
            self.coreDataStack.save(context: context)
        }
    }
    
    func deleteEntity(
        _ entityName: String,
        in context: NSManagedObjectContext
    ) {
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: entityName
        )
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            if let result = try context.execute(deleteRequest) as? NSBatchDeleteResult,
               let objectIDs = result.result as? [NSManagedObjectID] {
                
                let changes = [
                    NSDeletedObjectsKey: objectIDs
                ]
                
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [context]
                )
            }
        } catch {
            print("❌ Failed to delete \(entityName):", error)
        }
    }
}
