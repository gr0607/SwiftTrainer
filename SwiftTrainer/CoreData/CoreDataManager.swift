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
    
    // Category
    
    func addCategory(name: String) {
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
    
    // SubCategory
    
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
    
    // Question
    
    func fetchQuestions(for subCategory: SubCategory) -> [Question] {
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "parentSubCategory == %@", subCategory)
        
        return (try? context.fetch(request)) ?? []
    }
       
    func addQuestion(_ questionsData: questionForBase, for subCategory: SubCategory, context: NSManagedObjectContext) {
        for item in questionsData {
            let question = Question(context: context)
            question.questionText = item.question
            
            // гарантируем, что массив answers не пустой и есть 4 варианта
            if item.answers.count >= 4 {
                question.answer1 = item.answers[0]
                question.answer2 = item.answers[1]
                question.answer3 = item.answers[2]
                question.answer4 = item.answers[3]
            }
            
            question.correctAnswer = item.correctIndex
            question.hint = item.hint
            question.parentSubCategory = subCategory
        }
        
        do {
            try context.save()
            print("✅ Questions saved for \(subCategory.name)")
        } catch {
            print("❌ Failed to save questions: \(error)")
        }
    }

}
