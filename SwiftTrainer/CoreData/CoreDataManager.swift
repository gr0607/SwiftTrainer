//
//  CoreDataManager.swift
//  SwiftTrainer
//
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftTrainer") // название твоей .xcdatamodeld
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения Core Data: \(error)")
            }
        }
    }
    
    // MARK: - CRUD
    
    func createCategory(name: String, colorHex: String? = nil) {
        let category = Category(context: context)
        category.name = name
        saveContext()
    }
    
    func fetchCategories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки категорий: \(error)")
            return []
        }
    }
    
    func fetchSubcategories(for category: Category) -> [SubCategory] {
        let request: NSFetchRequest<SubCategory> = SubCategory.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory == %@", category)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка fetch SubCategory: \(error)")
            return []
        }
    }
    
    func fetchQuestions(for subCategory: SubCategory) -> [Question] {
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "parentSubCategory == %@", subCategory)
        
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Seed default data
       func seedDataIfNeeded() {
              
             
           let concurrencySubTitles = [
               "GCD (DispatchQueue)",
               "OperationQueue",
               "Async/Await",
               "Actors",
               "Synchronization",
               "Deadlocks & Race Conditions",
               "Timer & RunLoop"
           ]

           addSubcategories(to: "Concurrency", subTitles: concurrencySubTitles)
       }
    
    func addSubcategories(to categoryName: String, subTitles: [String]) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            if let category = try context.fetch(request).first {
                for title in subTitles {
                    // Проверим, нет ли уже такой подкатегории
                    if !(category.subcategories?.contains(where: { ($0 as? SubCategory)?.name == title }) ?? false) {
                        let sub = SubCategory(context: context)
                        sub.name = title
                        sub.parentCategory = category
                    }
                }
                try context.save()
                print("Подкатегории добавлены")
            } else {
                print("Категория \(categoryName) не найдена")
            }
        } catch {
            print(error)
        }
    }
    
    func fetchSubCategory(name: String, context: NSManagedObjectContext) -> SubCategory? {
        let request: NSFetchRequest<SubCategory> = SubCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
}
